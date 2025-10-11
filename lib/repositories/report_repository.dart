import 'dart:convert';
import 'package:ai_expense/models/report_model.dart';
import 'package:ai_expense/utils/local_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ai_expense/utils/backend.dart' as backendlink;

class ReportRepository {
  final String backend = backendlink.BACKEND;

  // Generate dummy data for testing
  List<ReportModel> _getDummyReports() {
    final now = DateTime.now();
    
    return [
      ReportModel(
        id: '1',
        month: 'October',
        year: 2025,
        isSeen: false,
        createdAt: now,
        additionalData: {
          'totalTransactions': 45,
          'totalAmount': 12450.50,
        },
      ),
      ReportModel(
        id: '2',
        month: 'September',
        year: 2025,
        isSeen: true,
        createdAt: now.subtract(const Duration(days: 30)),
        additionalData: {
          'totalTransactions': 52,
          'totalAmount': 15600.75,
        },
      ),
      ReportModel(
        id: '3',
        month: 'August',
        year: 2025,
        isSeen: true,
        createdAt: now.subtract(const Duration(days: 60)),
        additionalData: {
          'totalTransactions': 38,
          'totalAmount': 9800.25,
        },
      ),
      ReportModel(
        id: '4',
        month: 'July',
        year: 2025,
        isSeen: false,
        createdAt: now.subtract(const Duration(days: 90)),
        additionalData: {
          'totalTransactions': 41,
          'totalAmount': 11250.00,
        },
      ),
      ReportModel(
        id: '5',
        month: 'June',
        year: 2025,
        isSeen: true,
        createdAt: now.subtract(const Duration(days: 120)),
        additionalData: {
          'totalTransactions': 35,
          'totalAmount': 8900.50,
        },
      ),
      ReportModel(
        id: '6',
        month: 'May',
        year: 2025,
        isSeen: true,
        createdAt: now.subtract(const Duration(days: 150)),
        additionalData: {
          'totalTransactions': 48,
          'totalAmount': 13400.75,
        },
      ),
    ];
  }

  Future<List<ReportModel>> fetchReports() async {
    // For now, return dummy data with a simulated delay
    // Comment out the try-catch block below when API is ready
    
    print("Fetching reports with dummy data (API not implemented yet)");
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    return _getDummyReports();

    /* Uncomment this block when backend API is ready:
    
    final url = Uri.parse('$backend/api/reports');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${LocalStorage.getString('authToken')}",
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Handle both array response and object with 'reports' key
        List<dynamic> reportsJson;
        if (data is List) {
          reportsJson = data;
        } else if (data is Map && data.containsKey('reports')) {
          reportsJson = data['reports'];
        } else {
          reportsJson = [];
        }

        return reportsJson
            .map((json) => ReportModel.fromJson(json))
            .toList();
      } else {
        // If API fails, return dummy data as fallback
        print('API returned ${response.statusCode}, using dummy data');
        return _getDummyReports();
      }
    } catch (e) {
      // If any error occurs, return dummy data as fallback
      print('Error fetching reports: $e, using dummy data');
      return _getDummyReports();
    }
    
    */
  }
}
