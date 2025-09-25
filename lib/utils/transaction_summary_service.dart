// lib/services/transaction_summary_service.dart
import 'dart:convert';
import 'dart:io';

import 'package:ai_expense/models/summary_models.dart';
import 'package:ai_expense/utils/local_storage.dart'; // <-- 1. IMPORT LOCAL STORAGE
import 'package:http/http.dart' as http;

class TransactionSummaryService {
  String baseUrl;

  // The authToken property is no longer needed here

  TransactionSummaryService({
    this.baseUrl = 'https://capestone-backend-1-q0hb.onrender.com',
    // authToken parameter removed from constructor
  });

  Map<String, String> _defaultHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final token = LocalStorage.getString('authToken');

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<MonthlySummary> getMonthlySummary(int month, int year) async {
    final uri = Uri.parse(
      '$baseUrl/api/transactions/summaries/monthly/$month/$year',
    );
    final res = await http
        .get(uri, headers: _defaultHeaders())
        .timeout(const Duration(seconds: 10));

    if (res.statusCode != 200) {
      // Provide a more detailed error for debugging
      if (res.statusCode == 401) {
        throw Exception('Authorization failed: Token is invalid or expired.');
      }
      throw Exception('Failed to load summary: ${res.statusCode}');
    }

    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>;

    return MonthlySummary.fromJson(data);
  }

  Future<Map<String, dynamic>> getYearlySummary(int year) async {
    final uri = Uri.parse('$baseUrl/api/transactions/summaries/yearly/$year');

    final res = await http
        .get(uri, headers: _defaultHeaders())
        .timeout(const Duration(seconds: 10));

    if (res.statusCode != 200) {
      if (res.statusCode == 401) {
        throw Exception('Authorization failed: Token is invalid or expired.');
      }
      throw Exception('Failed to load yearly summary: ${res.statusCode}');
    }

    final Map<String, dynamic> body =
        jsonDecode(res.body) as Map<String, dynamic>;
    return body['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
  }

  String _monthName(int month) {
    const names = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    if (month >= 1 && month <= 12) return names[month];
    return 'Month $month';
  }

  void setBaseUrl(String url) => baseUrl = url;

  // 3. THE setAuthToken METHOD IS NO LONGER NEEDED AND HAS BEEN REMOVED
}
