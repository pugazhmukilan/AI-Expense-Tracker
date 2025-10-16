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
    print('\n');
    print('╔════════════════════════════════════════════════════════════════════════════╗');
    print('║                    HOME PAGE - MONTHLY SUMMARY API CALL                    ║');
    print('╚════════════════════════════════════════════════════════════════════════════╝');
    print('📅 Requesting Month: $month, Year: $year');
    print('🔗 Endpoint: /api/transactions/monthly?year=$year&month=$month');
    
    try {
      final token = LocalStorage.getString('authToken');
      if (token == null) {
        print('❌ ERROR: Authentication token not found');
        throw Exception('Authentication token not found');
      }
      print('✅ Auth Token Found: ${token.substring(0, 20)}...');

      final url = '$baseUrl/api/transactions/monthly?year=$year&month=$month';
      print('🚀 Making API Request to: $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('\n📥 API RESPONSE RECEIVED:');
      print('├─ Status Code: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        print('├─ Status: ✅ SUCCESS');
        final responseData = jsonDecode(response.body);
        
        print('├─ Response Body:');
        print('│  ${response.body}');
        print('│');
        print('├─ Parsed Data:');
        print('│  ├─ Success: ${responseData['success']}');
        
        if (responseData['success'] && responseData['data'] != null) {
          final data = responseData['data'];
          print('│  ├─ Total Transactions: ${data['total_transactions'] ?? 'N/A'}');
          print('│  ├─ Total Amount: ${data['formatted_total_amount'] ?? 'N/A'}');
          print('│  ├─ Total Debited: ${data['total_debited'] ?? 'N/A'}');
          print('│  ├─ Total Credited: ${data['total_credited'] ?? 'N/A'}');
          
          if (data['category_wise_summary'] != null) {
            final categories = data['category_wise_summary'] as Map<String, dynamic>;
            print('│  ├─ Categories Found: ${categories.keys.join(', ')}');
            print('│  │');
            
            categories.forEach((category, details) {
              print('│  ├─ Category: $category');
              print('│  │  ├─ Transaction Count: ${details['count']}');
              print('│  │  ├─ Total Amount: ${details['total_amount']}');
              
              if (details['transactions'] != null) {
                final transactions = details['transactions'] as List;
                print('│  │  └─ Sample Transactions (showing first 2):');
                
                for (var i = 0; i < (transactions.length > 2 ? 2 : transactions.length); i++) {
                  print('│  │     ├─ Transaction ${i + 1}:');
                  print('│  │     │  ├─ Merchant: ${transactions[i]['merchant']}');
                  print('│  │     │  ├─ Amount: ${transactions[i]['amount']}');
                  print('│  │     │  ├─ Type: ${transactions[i]['transaction_type']}');
                  print('│  │     │  └─ Date: ${transactions[i]['date']}');
                }
              }
            });
          }
          
          print('└─ ✅ Data Parsed Successfully');
          print('╚════════════════════════════════════════════════════════════════════════════╝\n');
          
          return MonthlyDetailsModel.fromJson(responseData['data']);
        } else {
          print('│  └─ ⚠️  Response success is false or data is null');
          print('└─ ❌ No Data Available');
          print('╚════════════════════════════════════════════════════════════════════════════╝\n');
          return null;
        }
      } else if (response.statusCode == 404) {
        print('├─ Status: ⚠️  NOT FOUND (404)');
        print('└─ No monthly details available for this period');
        print('╚════════════════════════════════════════════════════════════════════════════╝\n');
        return null;
      } else {
        print('├─ Status: ❌ ERROR (${response.statusCode})');
        print('├─ Error Response: ${response.body}');
        print('└─ Failed to fetch monthly details');
        print('╚════════════════════════════════════════════════════════════════════════════╝\n');
        throw Exception('Error fetching monthly details: ${response.body}');
      }
    } catch (e) {
      print('└─ ❌ EXCEPTION OCCURRED: $e');
      print('╚════════════════════════════════════════════════════════════════════════════╝\n');
      throw Exception('Exception in fetchMonthlyDetails: $e');
    }
  }
}
