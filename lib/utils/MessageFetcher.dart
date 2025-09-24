// import 'package:another_telephony/constants.dart';
// import 'package:another_telephony/filter.dart';
import 'dart:convert';

import 'package:another_telephony/telephony.dart';

class SmsService {
  final Telephony telephony = Telephony.instance;

  void sendSms(String message, String recipient) async {
    await telephony.sendSms(
      to: recipient,
      message: message,
    );
  }

        
  Future<List<SmsMessage>> fetchSmsFromDate(DateTime fromDate) async {
          // Convert date to milliseconds (since SmsColumn.DATE stores epoch time)
          int fromMillis = fromDate.millisecondsSinceEpoch;
          
          // Create the combined filter
          SmsFilter filter = SmsFilter.where(SmsColumn.DATE)
              .greaterThanOrEqualTo(fromMillis.toString())
              .and(SmsColumn.BODY)
              .like("%credit%")
              .or(SmsColumn.BODY)
              .like("%debit%");
          
          // Fetch SMS messages
          List<SmsMessage> messages = await telephony.getInboxSms(
            columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE,SmsColumn.SUBJECT],
            filter: filter,
            sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.ASC)],
          );
          
          return messages;
        }

  Future<String> fetchSmsAsJson(DateTime fromDate) async {
      // Get SMS messages using your existing function
      List<SmsMessage> messages = await fetchSmsFromDate(fromDate);
      
      // Convert to JSON format
      List<Map<String, dynamic>> jsonData = messages.map((sms) {
        return {
          'address': sms.address ?? '',
          'subject': sms.subject ?? '',
          'date': sms.date?.toString() ?? '',
          'transaction_type': _determineTransactionType(sms.body ?? ''),
          'body': sms.body ?? '',
          "amount": RegExp(r'(\d+[\.,]+\d*)').firstMatch(sms.body ?? '')?.group(0) ?? '0',
        };
      }).toList();
      
      // Convert to JSON string
      return jsonEncode(jsonData);
    }

    // Helper function to determine if it's debit or credit
  String _determineTransactionType(String body) {
      String lowerBody = body.toLowerCase();
      
      if (lowerBody.contains('credit') || lowerBody.contains('credited')) {
        return 'credited';
      } else if (lowerBody.contains('debit') || lowerBody.contains('debited')) {
        return 'debited';
      }
      
      // If both or neither are found, you might want to handle this case
      return 'unknown';
    }
}