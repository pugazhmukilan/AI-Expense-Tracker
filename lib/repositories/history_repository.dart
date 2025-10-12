import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ai_expense/models/yearly_summary_model.dart';
import 'package:ai_expense/utils/backend.dart' as backendlink;
import 'package:ai_expense/utils/local_storage.dart';

class HistoryRepository {
  final String baseUrl = backendlink.BACKEND;

  Future<YearlySummaryModel?> fetchYearlySummary() async {
    try {
      final token = LocalStorage.getString('authToken');
      if (token == null) {
        throw Exception('Authentication token not found');
      }
      final int year = DateTime.now().year;
      final response = await http.get(
        Uri.parse('$baseUrl/api/transactions/summaries/yearly/$year'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] && responseData['data'] != null) {
          return YearlySummaryModel.fromJson(responseData['data']);
        } else {
          return null;
        }
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Error fetching yearly summary: ${response.body}');
      }
    } catch (e) {
      throw Exception('Exception in fetchYearlySummary: $e');
    }
  }
}
