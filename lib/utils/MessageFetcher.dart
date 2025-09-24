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
    await telephony.sendSms(
      to: recipient,
      message: message,
    );
  }

        
  

  static Future<List<SmsMessage>> fetchSmsFromDate(DateTime fromDate) async {
    int fromMillis = fromDate.millisecondsSinceEpoch;

    // Step 1: Query all SMS after the given date
    SmsFilter filter = SmsFilter.where(SmsColumn.DATE)
        .greaterThanOrEqualTo(fromMillis.toString());

    List<SmsMessage> messages = await telephony.getInboxSms(
      columns: [
        SmsColumn.ADDRESS,
        SmsColumn.BODY,
        SmsColumn.DATE,
        SmsColumn.SUBJECT
      ],
      filter: filter,
      sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.ASC)],
    );

    // Step 2: Filter messages containing "debit" or "credit" in Dart
    List<SmsMessage> transactions = messages.where((sms) {
      final body = sms.body?.toLowerCase() ?? '';
      return body.contains('debit') || body.contains('credit');
    }).toList();

    
    return transactions;
  }
  static Future<List<Map<String,dynamic>>> fetchSms(DateTime fromDate) async {
      // Get SMS messages using your existing function
      List<SmsMessage> messages = await fetchSmsFromDate(fromDate);
      
      // Convert to JSON format
      List<Map<String, dynamic>> jsonData = messages.map((sms) {
        final dateMatch = RegExp(r'(\d{4}-\d{2}-\d{2})').firstMatch(sms.body ?? '');
        return {
          'address': sms.address ?? '',
          'subject': sms.subject ?? '',
          'date': dateMatch?.group(1) ?? '',
          'transaction_type': _determineTransactionType(sms.body ?? ''),
          "amount": RegExp(r'(\d+[\.,]+\d*)').firstMatch(sms.body ?? '')?.group(1) ?? '0',
          'body': sms.body ?? '',

          
        };
      }).toList();

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


 static Future<int> sendMessageToBackEnd(List<Map<String, dynamic>> messages) async {
  final url = Uri.parse('${backend}/api/transactions/batch');
  final headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer ${LocalStorage.getString('authToken')}"
  };
  
  final body = jsonEncode(messages); // send as array
  print("sending the message to the backend "+body);
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