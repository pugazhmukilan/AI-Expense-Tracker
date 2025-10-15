import 'dart:convert';
import 'package:ai_expense/models/monthly_chart_model.dart';
import 'package:http/http.dart' as http;
import 'package:ai_expense/utils/backend.dart' as backendlink;
import 'package:ai_expense/utils/local_storage.dart'; // 1. Import LocalStorage

class MonthlyChartRepository {
  final String _baseUrl = backendlink.BACKEND;

  Future<List<MonthlySpend>> fetchLastSixMonthsSpending() async {
    try {
      // 2. Get the token from local storage
      final String? token = LocalStorage.getString('token');

      if (token == null) {
        throw Exception(
          'Authentication token not found. User may be logged out.',
        );
      }

      // 3. Create the authorization headers
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(
        Uri.parse('$_baseUrl/api/transactions/last-six-months'),
        headers: headers, // 4. Add the headers to your request
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = jsonDecode(response.body);
        final List<dynamic> monthsList = decodedJson['data']['months'];
        print("Fetched Monthly Chart Data: $monthsList");
        return monthsList.map((json) => MonthlySpend.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load chart data: ${response.statusCode}');
      }
    } catch (e) {
      print('--- ERROR FETCHING CHART DATA ---');
      print(e);
      throw Exception('Failed to load monthly chart data');
    }
  }
}
