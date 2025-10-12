import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ai_expense/models/category_details_model.dart';
import 'package:ai_expense/utils/backend.dart' as backendlink;
import 'package:ai_expense/utils/local_storage.dart';

class CategoryDetailsRepository {
  final String baseUrl = backendlink.BACKEND;

  Future<CategoryDetailsModel?> fetchCategoryDetails({
    required String category,
    required int month,
    required int year,
  }) async {
    try {
      final token = LocalStorage.getString('authToken');
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/transactions/category?category=$category&month=$month&year=$year'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('========== CATEGORY DETAILS API RESPONSE ==========');
      print('URL: $baseUrl/api/transactions/category?category=$category&month=$month&year=$year');
      print('Category: $category, Month: $month, Year: $year');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Response parsed successfully');
        print('Success: ${responseData['success']}');
        print('Data exists: ${responseData['data'] != null}');
        
        if (responseData['success'] && responseData['data'] != null) {
          try {
            print('Attempting to parse model...');
            print('Data keys: ${responseData['data'].keys}');
            
            final model = CategoryDetailsModel.fromJson(responseData['data']);
            print('Model created successfully');
            print('Merchant count: ${model.merchantBreakdown.length}');
            
            // Print first merchant details for debugging
            if (model.merchantBreakdown.isNotEmpty) {
              final firstMerchant = model.merchantBreakdown.first;
              print('First merchant: ${firstMerchant.merchant}');
              print('Debited: ${firstMerchant.formattedDebitedAmount}');
              print('Credited: ${firstMerchant.formattedCreditedAmount}');
            }
            
            print('==================================================');
            return model;
          } catch (e, stackTrace) {
            print('Error parsing model: $e');
            print('Stack trace: $stackTrace');
            print('Raw data structure: ${responseData['data']}');
            print('==================================================');
            throw Exception('Error parsing response: $e');
          }
        } else {
          print('Response success is false or data is null');
          print('==================================================');
          return null;
        }
      } else if (response.statusCode == 404) {
        print('Category details not found (404)');
        print('==================================================');
        return null;
      } else {
        print('Error Response Code: ${response.statusCode}');
        print('==================================================');
        throw Exception('Error fetching category details: ${response.body}');
      }
    } catch (e) {
      print('Exception in fetchCategoryDetails: $e');
      throw Exception('Exception in fetchCategoryDetails: $e');
    }
  }
}
