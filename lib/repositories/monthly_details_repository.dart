import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ai_expense/models/monthly_details_model.dart';
import 'package:ai_expense/utils/backend.dart' as backendlink;
import 'package:ai_expense/utils/local_storage.dart';

class MonthlyDetailsRepository {
  final String baseUrl = backendlink.BACKEND;

  Future<MonthlyDetailsModel?> fetchMonthlyDetails({
    required int year,
    required int month,
  }) async {
    try {
      final token = LocalStorage.getString('authToken');
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/transactions/monthly?year=$year&month=$month'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        // Print the raw API response
        print('========== MONTHLY DETAILS API RESPONSE ==========');
        print('Status Code: ${response.statusCode}');
        print('Full Response Body: ${response.body}');
        print('==================================================');
        
        if (responseData['success'] && responseData['data'] != null) {
          // Print specific transaction details
          print('========== TRANSACTION DETAILS ==========');
          if (responseData['data']['category_wise_summary'] != null) {
            final categories = responseData['data']['category_wise_summary'] as Map<String, dynamic>;
            categories.forEach((category, details) {
              print('\nCategory: $category');
              print('Count: ${details['count']}');
              if (details['transactions'] != null) {
                final transactions = details['transactions'] as List;
                for (var i = 0; i < transactions.length; i++) {
                  print('\n  Transaction ${i + 1}:');
                  print('  - ID: ${transactions[i]['_id']}');
                  print('  - Merchant: ${transactions[i]['merchant']}');
                  print('  - Amount: ${transactions[i]['amount']}');
                  print('  - Transaction Type: ${transactions[i]['transaction_type']}');
                  print('  - Date: ${transactions[i]['date']}');
                  print('  - Subject: ${transactions[i]['subject']}');
                  print('  - Body: ${transactions[i]['body']}');
                }
              }
            });
          }
          print('=========================================');
          
          return MonthlyDetailsModel.fromJson(responseData['data']);
        } else {
          print('Response success is false or data is null');
          return null;
        }
      } else if (response.statusCode == 404) {
        print('Monthly details not found (404)');
        return null;
      } else {
        print('Error Response: ${response.body}');
        throw Exception('Error fetching monthly details: ${response.body}');
      }
    } catch (e) {
      throw Exception('Exception in fetchMonthlyDetails: $e');
    }
  }
}
