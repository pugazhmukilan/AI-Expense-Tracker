import 'package:ai_expense/bloc/report_bloc.dart';
import 'package:ai_expense/bloc/report_event.dart';
import 'package:ai_expense/bloc/report_state.dart';
import 'package:ai_expense/screens/AnalysisReports/widgets/category_breakdown_widget.dart';
import 'package:ai_expense/screens/AnalysisReports/widgets/error_state_widget.dart';
import 'package:ai_expense/screens/AnalysisReports/widgets/report_details_loading_widget.dart';
import 'package:ai_expense/screens/AnalysisReports/widgets/summary_card_widget.dart';
import 'package:ai_expense/screens/AnalysisReports/widgets/top_expenses_widget.dart';
import 'package:ai_expense/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportDetailsScreen extends StatefulWidget {
  final String reportId;
  final String reportTitle; // e.g., "September 2025"

  const ReportDetailsScreen({
    Key? key,
    required this.reportId,
    required this.reportTitle,
  }) : super(key: key);

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  final List<String> _loadingMessages = [
    "Analyzing your expenses...",
    "Crunching the numbers...",
    "Preparing your report...",
    "Almost ready...",
    "Just a moment more...",
  ];

  int _currentMessageIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<ReportBloc>().add(FetchReportDetails(reportId: widget.reportId));

    // Change loading message every 3 seconds
    Future.delayed(const Duration(seconds: 3), _cycleLoadingMessage);
  }

  void _cycleLoadingMessage() {
    if (mounted && context.read<ReportBloc>().state is ReportDetailsFetching) {
      setState(() {
        _currentMessageIndex =
            (_currentMessageIndex + 1) % _loadingMessages.length;
      });
      Future.delayed(const Duration(seconds: 3), _cycleLoadingMessage);
    }
  }

  void _handleRetry() {
    context.read<ReportBloc>().add(FetchReportDetails(reportId: widget.reportId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          
          onPressed: () {
            
            Navigator.pop(context);
          } 
        ),
        title: Text(
          widget.reportTitle,
          style: const TextStyle(
            fontFamily: "Poppins",
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg/crystalbg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: BlocBuilder<ReportBloc, ReportState>(
          builder: (context, state) {
            if (state is ReportDetailsFetching) {
              return ReportDetailsLoadingWidget(
                currentMessage: _loadingMessages[_currentMessageIndex],
              );
            } else if (state is ReportDetailsFetched) {
              return _buildReportDetails(state);
            } else if (state is ReportDetailsError) {
              return ErrorStateWidget(
                message: state.message,
                onRetry: _handleRetry,
              );
            }
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildReportDetails(ReportDetailsFetched state) {
    final report = state.reportDetails;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Summary Cards Row
        Row(
          children: [
            Expanded(
              child: SummaryCardWidget(
                title: 'Total Spent',
                value: '₹${report.totalAmount.toStringAsFixed(2)}',
                icon: Icons.account_balance_wallet,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SummaryCardWidget(
                title: 'Transactions',
                value: '${report.totalTransactions}',
                icon: Icons.receipt_long,
                color: AppColors.tertiary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Summary Text
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.insights,
                    color: AppColors.tertiary,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Summary',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                report.summary,
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Category Breakdown
        CategoryBreakdownWidget(
          categoryBreakdown: report.categoryBreakdown,
          totalAmount: report.totalAmount,
        ),
        const SizedBox(height: 20),

        // Top Expenses
        TopExpensesWidget(
          topExpenses: report.topExpenses,
        ),
        const SizedBox(height: 20),

        // Additional Info (if available)
        if (report.additionalData != null &&
            report.additionalData!.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Additional Insights',
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                if (report.additionalData!['averageTransactionAmount'] != null)
                  _buildInfoRow(
                    'Average Transaction',
                    '₹${(report.additionalData!['averageTransactionAmount'] as num).toStringAsFixed(2)}',
                    Icons.trending_flat,
                  ),
                if (report.additionalData!['largestTransaction'] != null)
                  _buildInfoRow(
                    'Largest Transaction',
                    '₹${(report.additionalData!['largestTransaction'] as num).toStringAsFixed(2)}',
                    Icons.arrow_upward,
                  ),
                if (report.additionalData!['mostFrequentCategory'] != null)
                  _buildInfoRow(
                    'Most Frequent Category',
                    report.additionalData!['mostFrequentCategory'].toString(),
                    Icons.category,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
