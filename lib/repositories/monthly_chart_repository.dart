import 'dart:convert';
import 'package:ai_expense/models/monthly_chart_model.dart';
import 'package:http/http.dart' as http;
import 'package:ai_expense/utils/backend.dart' as backendlink;
import 'package:ai_expense/utils/local_storage.dart'; // 1. Import LocalStorage

class MonthlyChartRepository {
  final String _baseUrl = backendlink.BACKEND;

  Future<List<MonthlySpend>> fetchLastSixMonthsSpending() async {
    print('\n');
    print('╔════════════════════════════════════════════════════════════════════════════╗');
    print('║                    HOME PAGE - SPENDING CHART API CALL                     ║');
    print('╚════════════════════════════════════════════════════════════════════════════╝');
    print('📊 Requesting: Last 6 months spending data');
    print('🔗 Endpoint: /api/transactions/last-six-months');
    
    try {
      final String? token = LocalStorage.getString('token');

      if (token == null) {
        print('❌ ERROR: Authentication token not found');
        throw Exception(
          'Authentication token not found. User may be logged out.',
        );
      }
      print('✅ Auth Token Found: ${token.substring(0, 20)}...');

      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final url = '$_baseUrl/api/transactions/last-six-months';
      print('🚀 Making API Request to: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print('\n📥 API RESPONSE RECEIVED:');
      print('├─ Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('├─ Status: ✅ SUCCESS');
        final Map<String, dynamic> decodedJson = jsonDecode(response.body);
        
        print('├─ Response Body:');
        print('│  ${response.body}');
        print('│');
        
        final List<dynamic> monthsList = decodedJson['data']['months'];
        print('├─ Parsed Data:');
        print('│  ├─ Number of Months: ${monthsList.length}');
        print('│  │');
        
        for (var i = 0; i < monthsList.length; i++) {
          final month = monthsList[i];
          print('│  ├─ Month ${i + 1}:');
          print('│  │  ├─ Month Name: ${month['monthName']}');
          print('│  │  ├─ Month Number: ${month['month']}');
          print('│  │  ├─ Year: ${month['year']}');
          print('│  │  └─ Total Amount: ${month['totalAmount']}');
        }
        
        print('└─ ✅ Chart Data Parsed Successfully');
        print('╚════════════════════════════════════════════════════════════════════════════╝\n');
        
        return monthsList.map((json) => MonthlySpend.fromJson(json)).toList();
      } else {
        print('├─ Status: ❌ ERROR (${response.statusCode})');
        print('├─ Error Response: ${response.body}');
        print('└─ Failed to load chart data');
        print('╚════════════════════════════════════════════════════════════════════════════╝\n');
        throw Exception('Failed to load chart data: ${response.statusCode}');
      }
    } catch (e) {
      print('└─ ❌ EXCEPTION OCCURRED: $e');
      print('╚════════════════════════════════════════════════════════════════════════════╝\n');
      throw Exception('Failed to load monthly chart data');
    }
  }
}
