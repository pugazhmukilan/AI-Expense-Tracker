// import 'package:another_telephony/constants.dart';
// import 'package:another_telephony/filter.dart';
import 'dart:convert';

import 'package:ai_expense/utils/local_storage.dart';
import 'package:another_telephony/telephony.dart';
import 'package:http/http.dart' as http;
import "package:ai_expense/utils/backend.dart" as backendlink;

class SmsService {
  static final Telephony telephony = Telephony.instance;
  static final backend = backendlink.BACKEND;

  void sendSms(String message, String recipient) async {
    await telephony.sendSms(to: recipient, message: message);
  }

  static Future<List<SmsMessage>> fetchSmsFromDate(DateTime fromDate) async {
    int fromMillis = fromDate.millisecondsSinceEpoch;

    // Step 1: Query all SMS after the given date
    SmsFilter filter = SmsFilter.where(
      SmsColumn.DATE,
    ).greaterThanOrEqualTo(fromMillis.toString());

    List<SmsMessage> messages = await telephony.getInboxSms(
      columns: [
        SmsColumn.ADDRESS,
        SmsColumn.BODY,
        SmsColumn.DATE,
        SmsColumn.SUBJECT,
        
      ],
      filter: filter,
      sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.ASC)],
    );

    // Step 2: Filter messages containing "debit" or "credit" in Dart
    List<SmsMessage> transactions =
        messages.where((sms) {
          final body = sms.body?.toLowerCase() ?? '';
          return body.contains('debit') || body.contains('credit');
        }).toList();

    return transactions;
  }

  static Future<List<Map<String, dynamic>>> fetchSms(DateTime fromDate) async {
    // Get SMS messages using your existing function
    //DateTime fromDate = DateTime(2025, 10, 1);
    List<SmsMessage> messages = await fetchSmsFromDate(fromDate);

    // Convert to JSON format using sms.date and filter out incomplete messages
    List<Map<String, dynamic>> jsonData =
        messages
            .map((sms) {
              // Use sms.date (milliseconds since epoch) and convert to ISO8601 string
              String formattedDate = '';
              if (sms.date != null) {
                final dt = DateTime.fromMillisecondsSinceEpoch(sms.date!);
                formattedDate =
                    dt.toIso8601String(); // e.g., 2025-09-25T10:15:30.000
              }

              final address = sms.address ?? '';
              final body = sms.body ?? '';
              final transactionType = _determineTransactionType(body);
              // final amountMatch = RegExp(r'(\d+[\.,]?\d*)').firstMatch(body);
              final amountMatch = RegExp(r'Rs\.?\s*(\d+[\.,]?\d*)').firstMatch(body);
              final amount = amountMatch?.group(1) ?? '';
              final personName = _extractPersonName(body);
              final remarkMatch = RegExp(r'Payer Remark -\s*(.*)$').firstMatch(body);
              final subject = remarkMatch != null ? remarkMatch.group(1)?.trim() ?? '' : '';

              return {
                'address': address,
                'subject':subject,
                'date': formattedDate,
                'transaction_type': transactionType,
                'amount': amount,
                'merchant': personName,
                'body': body,
              };
            })
            // Filter out messages missing required fields
            .where(
              (msg) =>
                  msg['address'] != '' &&
                  msg['date'] != '' &&
                  msg['transaction_type'] != 'unknown' &&
                  msg['body'] != '' &&
                  msg['amount'] != '',
            )
            .toList();

    print("==========================================================================");
    for (var data in jsonData) {
      print(data);
    }
    print("==========================================================================");
    // if len of data is more than 0 then only send to the backend
    int answer = await sendMessageToBackEnd(jsonData);
    print("asnwer is ${answer}");
    //Convert to JSON string
    return jsonData;
  }

 
  static String _determineTransactionType(String body) {
    String lowerBody = body.toLowerCase();

    if (lowerBody.contains('credit') || lowerBody.contains('credited')) {
      return 'credited';
    } else if (lowerBody.contains('debit') || lowerBody.contains('debited')) {
      return 'debited';
    }

    // If both or neither are found, you might want to handle this case
    return 'unknown';
  }

  
  // static String _extractPersonName(String body) {
  //   // Common patterns in transaction SMS:
  //   // "sent to NAME", "from NAME", "to NAME", "by NAME", "paid to NAME"
    
  //   final patterns = [
  //     RegExp(r'from\s+([A-Za-z.\s]+?)(?:-|\(|$)', caseSensitive: false),
  //     RegExp(r'for payee\s+([A-Za-z.\s]+?)\s+for\s+Rs', caseSensitive: false),
  //   ];

  //   for (var pattern in patterns) {
  //     final match = pattern.firstMatch(body);
  //     if (match != null && match.groupCount >= 1) {
  //       String name = match.group(1)?.trim() ?? '';
  //       // Clean up the name - remove extra spaces and common suffixes
  //       name = name.replaceAll(RegExp(r'\s+'), ' ').trim();
  //       if (name.isNotEmpty && name.length > 1) {
  //         return name;
  //       }
  //     }
  //   }

  //   return 'Unknown';
  // }

  static String _extractPersonName(String body) {
    // 1. Prioritized Patterns for Payee/Payer (Entity associated with the name)
    final prioritizedPatterns = [
        // Pattern 1: Credit message - finds the entity *after* "from" or "by a/c linked to VPA"
        // Captures: "from HEMANTH KUMAR K R-" or "by a/c linked to VPA hemanthsiva2022@okaxis"
        RegExp(r'(?:from|by a/c linked to VPA)\s+([A-Za-z\s.\-]+?)(?:-|@|\(|UPI|Ref|is credited|credited|$)', caseSensitive: false),
        
        // Pattern 2: Debit message - finds the entity *after* "for payee"
        // Captures: "for payee Mr Jotham Emmanuel Cheeran for Rs." or "for payee Anu__Foods"
        RegExp(r'for payee\s+([A-Za-z\s_]+?)\s+for\s+Rs', caseSensitive: false),
        
        // Pattern 3: Debit message - finds the entity *after* "debited for payee"
        RegExp(r'debited for payee\s+([A-Za-z\s_]+?)\s+for\s+Rs', caseSensitive: false),

        // Pattern 4: Debit/Credit message from Indian/ICICI Bank. Finds entity *after* "to" (for debit) or "from" (for credit).
        // Captures: "debited Rs. 30.00 on DATE to KOMMURI BHUPATHI."
        // Captures: "credited with Rs 10.00 on DATE from PUGAZHMUKILAN J."
        RegExp(r'(?:to|from)\s+([A-Za-z\s]+?)\.?(?:\s*UPI|credited|debited|$)', caseSensitive: false),
        
        // Pattern 5: Google Pay money request - finds the entity *before* "has requested money"
        // Captures: "CHENNAI METRO RAIL LTD has requested" or "IRCTC CF has requested"
        RegExp(r'^body\d+:\s*([A-Za-z0-9\s]+?)\s+has requested money', caseSensitive: false),
        
        // Pattern 6: Google Pay request, simplified - finds the entity *before* "has requested" or "requested"
        // Captures: "IRCTC CF has requested"
        RegExp(r'^body\d+:\s*([A-Za-z0-9\s]+?)\s+requested money|has requested', caseSensitive: false),

        // Pattern 7: Direct payment/transfer name. Finds name before "credited" or "debited" and after a number/currency.
        // Captures: "ICICI Bank Acct XX240 debited for Rs 1.00 on 16-Oct-25; jotham05cheeran credited."
        RegExp(r';\s*([A-Za-z0-9]+)\s+credited', caseSensitive: false),
        
        // Pattern 8: Debit/Credit - find entity after "to" or "from" but before UPI/Not you. (for Indian Bank specifically)
        // Captures: "A/c *4293 debited Rs. 30.00 on 15-10-25 to KOMMURI BHUPATHI. UPI:..."
        RegExp(r'(?:to|from)\s+([A-Za-z\s]+?)\.\s+UPI', caseSensitive: false),
        
        // Pattern 9: Generic "paid to" pattern from the user's remark examples (body 1571)
        RegExp(r'Paid to\s+([A-Za-z\s]+)', caseSensitive: false),
    ];
    
    // 2. Fallback pattern for VPA extraction
    final vpaFallback = RegExp(r'VPA\s+([a-zA-Z0-9.\-]+?)(?:@)', caseSensitive: false);

    for (var pattern in prioritizedPatterns) {
        final match = pattern.firstMatch(body);
        if (match != null && match.groupCount >= 1) {
            String name = match.group(1)?.trim() ?? '';
            // Clean up name: remove common punctuation/symbols/prefixes/suffixes
            name = name.replaceAll(RegExp(r'[\s.!@#$,;]+'), ' ').trim();
            name = name.replaceAll(RegExp(r'^(Mr|Ms|Dr)\s+', caseSensitive: false), '').trim();
            // Capitalize if it looks like a VPA part that got caught
            if (name.contains(RegExp(r'^[a-z]+[0-9]+$', caseSensitive: false))) {
                 name = name.toUpperCase();
            }
            
            // Filter out clearly unwanted matches
            if (name.isNotEmpty && name.length > 2 && !name.contains(RegExp(r'A/c|Acct|no\.', caseSensitive: false))) {
                return name;
            }
        }
    }
    
    // Fallback to extract entity from VPA if a name couldn't be found
    final vpaMatch = vpaFallback.firstMatch(body);
    if (vpaMatch != null && vpaMatch.groupCount >= 1) {
        String vpaPart = vpaMatch.group(1)?.trim() ?? '';
        // Often the VPA part is the name, sometimes with a number suffix.
        if (vpaPart.isNotEmpty && vpaPart.length > 2) {
             // Heuristic: If it contains mixed case/numbers, format it nicely.
             // E.g., 'jotham05cheeran' -> 'JOTHAM05CHEERAN'
             if (vpaPart.contains(RegExp(r'[0-9]')) || vpaPart.contains(RegExp(r'[A-Z]'))) {
                 vpaPart = vpaPart.toUpperCase();
             }
             return vpaPart;
        }
    }
    
    // Final check for the common but less precise pattern in case others fail
     final simplePattern = RegExp(r'from\s+([A-Za-z.\s]+?)(?:-|\(|$)', caseSensitive: false);
     final simpleMatch = simplePattern.firstMatch(body);
     if (simpleMatch != null && simpleMatch.groupCount >= 1) {
         String name = simpleMatch.group(1)?.trim() ?? '';
         name = name.replaceAll(RegExp(r'\s+'), ' ').trim();
         if (name.isNotEmpty && name.length > 1 && !name.contains(RegExp(r'SBI|IOB|ICICI', caseSensitive: false))) {
              return name;
         }
     }

    return 'Unknown Entity';
}

  static Future<int> sendMessageToBackEnd(
    List<Map<String, dynamic>> messages,
  ) async {
    final url = Uri.parse('${backend}/api/transactions/batch');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${LocalStorage.getString('authToken')}",
    };

    final body = jsonEncode(messages); // send as array
    print("sending the message to the backend " + body);
    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Messages sent successfully');
      } else {
        print('Failed to send messages. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      return response.statusCode;
    } catch (error) {
      print('Error sending messages: $error');
      return 500;
    }
  }
}
