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
              final amountMatch = RegExp(r'(\d+[\.,]?\d*)').firstMatch(body);
              final amount = amountMatch?.group(1) ?? '';

              return {
                'address': address,
                'subject': sms.subject ?? '',
                'date': formattedDate,
                'transaction_type': transactionType,
                'amount': amount,
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

    for (var data in jsonData) {
      print(data);
    }
    // if len of data is more than 0 then only send to the backend
    int answer = await sendMessageToBackEnd(jsonData);
    print("asnwer is ${answer}");
    //Convert to JSON string
    return jsonData;
  }

  // Helper function to determine if it's debit or credit
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
