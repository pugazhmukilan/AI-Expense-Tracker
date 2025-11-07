import 'package:ai_expense/bloc/analysis_bloc.dart';
import 'package:ai_expense/bloc/analysis_event.dart';
import 'package:ai_expense/bloc/analysis_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:ai_expense/models/monthly_analysis_model.dart';
import 'package:ai_expense/repositories/report_repository.dart';

// --- Import your existing widgets ---
import 'package:ai_expense/screens/AnalysisReports/widgets/summary_card_widget.dart';
import 'package:ai_expense/screens/AnalysisReports/widgets/category_breakdown_widget.dart';
import 'package:ai_expense/screens/AnalysisReports/widgets/error_state_widget.dart';
import 'package:ai_expense/screens/AnalysisReports/widgets/report_details_loading_widget.dart';
import 'package:ai_expense/theme/app_theme.dart';

class MonthlyAnalysisScreen extends StatelessWidget {
  final int year;
  final int month;

  const MonthlyAnalysisScreen({
    Key? key,
    required this.year,
    required this.month,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              AnalysisBloc(reportRepository: context.read<ReportRepository>())
                ..add(FetchAnalysis(year: year, month: month)),
      // We pass year and month to the View
      child: MonthlyAnalysisView(year: year, month: month),
    );
  }
}

class MonthlyAnalysisView extends StatefulWidget {
  final int year;
  final int month;

  const MonthlyAnalysisView({Key? key, required this.year, required this.month})
    : super(key: key);

  @override
  State<MonthlyAnalysisView> createState() => _MonthlyAnalysisViewState();
}

class _MonthlyAnalysisViewState extends State<MonthlyAnalysisView> {
  // Copied from your ReportDetailsScreen
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
    // Start the loading message cycler
    Future.delayed(const Duration(seconds: 3), _cycleLoadingMessage);
  }

  void _cycleLoadingMessage() {
    // Check if we are still mounted and still loading
    if (mounted && context.read<AnalysisBloc>().state is AnalysisLoading) {
      setState(() {
        _currentMessageIndex =
            (_currentMessageIndex + 1) % _loadingMessages.length;
      });
      Future.delayed(const Duration(seconds: 3), _cycleLoadingMessage);
    }
  }

  void _handleRetry() {
    context.read<AnalysisBloc>().add(
      FetchAnalysis(year: widget.year, month: widget.month),
    );
  }

  void _handleGenerate() {
    context.read<AnalysisBloc>().add(
      GenerateAnalysis(year: widget.year, month: widget.month),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${DateFormat.MMMM().format(DateTime(widget.year, widget.month))}, ${widget.year}',
          style: const TextStyle(
            fontFamily: "Poppins",
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              context.read<AnalysisBloc>().add(
                UpdateAnalysis(year: widget.year, month: widget.month),
              );
            },
          ),
        ],
      ),
      body: Container(
        // Using the same background image decoration
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg/crystalbg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: BlocBuilder<AnalysisBloc, AnalysisState>(
          builder: (context, state) {
            if (state is AnalysisLoading) {
              return ReportDetailsLoadingWidget(
                currentMessage: _loadingMessages[_currentMessageIndex],
              );
            }

            if (state is AnalysisFetched) {
              return _buildReportDetails(context, state.analysis);
            }

            if (state is AnalysisNotGenerated) {
              // We don't have an EmptyStateWidget, so we build one
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.insights_rounded,
                        size: 80,
                        color: Colors.white70,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Analysis not generated for this month.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: "Poppins",
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _handleGenerate,
                        child: Text('Generate Now'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is AnalysisError) {
              return ErrorStateWidget(
                message: state.message,
                onRetry: _handleRetry,
              );
            }

            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          },
        ),
      ),
    );
  }

  /// This helper creates the standard white card decoration
  /// from your ReportDetailsScreen
  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// This helper is copied directly from your ReportDetailsScreen
  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
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

  /// This is the main UI builder, now matching your old screen's layout
  Widget _buildReportDetails(
    BuildContext context,
    MonthlyAnalysisModel analysis,
  ) {
    // Formatter for currency
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // --- 1. Summary Cards Row ---
        // Uses your existing SummaryCardWidget
        Row(
          children: [
            Expanded(
              child: SummaryCardWidget(
                title: 'Total Spent',
                value: currencyFormatter.format(analysis.debitedAmount),
                icon: Icons.account_balance_wallet,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SummaryCardWidget(
                title: 'Transaction',
                value: '${analysis.totalTransactions}',
                icon: Icons.receipt_long,
                color: AppColors.tertiary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // --- 2. Summary Text Card ---
        // Styled just like your ReportDetailsScreen
        Container(
          padding: const EdgeInsets.all(20),
          decoration: _buildCardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.insights, color: AppColors.tertiary, size: 24),
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
                analysis.summary,
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

        // --- 3. Suggestions Card (Replaces TopExpenses) ---
        // This is new, but styled to look like your other cards
        Container(
          padding: const EdgeInsets.all(20),
          decoration: _buildCardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: AppColors.tertiary,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Suggestions',
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
              ...analysis.suggestions
                  .map(
                    (suggestion) => Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        '• $suggestion', // Simple bullet point
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // --- 4. Category Breakdown Card ---
        // Uses your existing CategoryBreakdownWidget
        CategoryBreakdownWidget(
          categoryBreakdown: analysis.categoryBreakdown,
          // We pass debitedAmount as the "total" for breakdown
          totalAmount: analysis.debitedAmount,
        ),
        const SizedBox(height: 20),

        // --- 5. Additional Info Card ---
        // Re-implements your Additional Insights section
        Container(
          padding: const EdgeInsets.all(20),
          decoration: _buildCardDecoration(),
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
              _buildInfoRow(
                'Total Income',
                currencyFormatter.format(analysis.creditedAmount),
                Icons.arrow_downward,
              ),
              _buildInfoRow(
                'Net Monthly Flow',
                currencyFormatter.format(analysis.totalAmount),
                Icons.trending_flat,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
