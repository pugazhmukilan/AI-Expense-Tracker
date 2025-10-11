import 'dart:convert';
import 'package:ai_expense/models/report_model.dart';
import 'package:ai_expense/models/report_details_model.dart';
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

  // Generate dummy report details for testing
  ReportDetailsModel _getDummyReportDetails(String reportId) {
    final now = DateTime.now();
    
    // Find the matching report from dummy reports
    final dummyReports = _getDummyReports();
    final report = dummyReports.firstWhere(
      (r) => r.id == reportId,
      orElse: () => dummyReports.first,
    );

    return ReportDetailsModel(
      id: reportId,
      month: report.month,
      year: report.year,
      isSeen: report.isSeen,
      createdAt: report.createdAt,
      totalAmount: (report.additionalData?['totalAmount'] ?? 10000.0).toDouble(),
      totalTransactions: report.additionalData?['totalTransactions'] ?? 40,
      categoryBreakdown: {
        'Food & Dining': 3500.0,
        'Transportation': 1200.0,
        'Shopping': 2800.0,
        'Entertainment': 1500.0,
        'Bills & Utilities': 2000.0,
        'Healthcare': 800.0,
        'Others': 650.0,
      },
      topExpenses: [
        TopExpense(
          description: 'Grocery Shopping',
          amount: 2500.0,
          category: 'Food & Dining',
          date: now.subtract(const Duration(days: 5)),
          merchant: 'Supermarket',
        ),
        TopExpense(
          description: 'Restaurant Dinner',
          amount: 1800.0,
          category: 'Food & Dining',
          date: now.subtract(const Duration(days: 10)),
          merchant: 'The Fancy Restaurant',
        ),
        TopExpense(
          description: 'Online Shopping',
          amount: 1500.0,
          category: 'Shopping',
          date: now.subtract(const Duration(days: 15)),
          merchant: 'Amazon',
        ),
        TopExpense(
          description: 'Electric Bill',
          amount: 1200.0,
          category: 'Bills & Utilities',
          date: now.subtract(const Duration(days: 20)),
          merchant: 'Power Company',
        ),
        TopExpense(
          description: 'Fuel',
          amount: 800.0,
          category: 'Transportation',
          date: now.subtract(const Duration(days: 3)),
          merchant: 'Gas Station',
        ),
      ],
      summary: 'Your spending for ${report.month} ${report.year} shows a total of ₹${(report.additionalData?['totalAmount'] ?? 10000.0).toStringAsFixed(2)} across ${report.additionalData?['totalTransactions'] ?? 40} transactions. Your highest spending category was Food & Dining, followed by Shopping and Bills & Utilities.',
      additionalData: {
        'averageTransactionAmount': 250.0,
        'largestTransaction': 2500.0,
        'mostFrequentCategory': 'Food & Dining',
      },
    );
  }

  Future<ReportDetailsModel> fetchReportDetails(String reportId) async {
    // For now, return dummy data with a simulated delay
    // Comment out the block below when API is ready
    
    print("Fetching report details for ID: $reportId (using dummy data)");
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    return _getDummyReportDetails(reportId);

    /* Uncomment this block when backend API is ready:
    
    final url = Uri.parse('$backend/api/reports/$reportId');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${LocalStorage.getString('authToken')}",
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ReportDetailsModel.fromJson(data);
      } else {
        // If API fails, return dummy data as fallback
        print('API returned ${response.statusCode}, using dummy data');
        return _getDummyReportDetails(reportId);
      }
    } catch (e) {
      // If any error occurs, return dummy data as fallback
      print('Error fetching report details: $e, using dummy data');
      return _getDummyReportDetails(reportId);
    }
    
    */
  }
}

