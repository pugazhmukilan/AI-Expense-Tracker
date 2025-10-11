import 'package:ai_expense/bloc/report_bloc.dart';
import 'package:ai_expense/bloc/report_event.dart';
import 'package:ai_expense/bloc/report_state.dart';
import 'package:ai_expense/models/report_model.dart';
import 'package:ai_expense/screens/AnalysisReports/report_details_screen.dart';
import 'package:ai_expense/screens/AnalysisReports/widgets/empty_state_widget.dart';
import 'package:ai_expense/screens/AnalysisReports/widgets/error_state_widget.dart';
import 'package:ai_expense/screens/AnalysisReports/widgets/loading_state_widget.dart';
import 'package:ai_expense/screens/AnalysisReports/widgets/reports_list_widget.dart';
import 'package:ai_expense/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnalysisReportsScreen extends StatefulWidget {
  const AnalysisReportsScreen({Key? key}) : super(key: key);

  @override
  State<AnalysisReportsScreen> createState() => _AnalysisReportsScreenState();
}

class _AnalysisReportsScreenState extends State<AnalysisReportsScreen> {
  final List<String> _loadingMessages = [
    "Fetching your reports...",
    "This might take a moment...",
    "We're working on it...",
    "Analyzing your data...",
    "Almost there...",
    "Thanks for your patience...",
  ];

  int _currentMessageIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<ReportBloc>().add(FetchReports());

    // Change loading message every 3 seconds
    Future.delayed(const Duration(seconds: 3), _cycleLoadingMessage);
  }

  void _cycleLoadingMessage() {
    if (mounted && context.read<ReportBloc>().state is ReportFetching) {
      setState(() {
        _currentMessageIndex =
            (_currentMessageIndex + 1) % _loadingMessages.length;
      });
      Future.delayed(const Duration(seconds: 3), _cycleLoadingMessage);
    }
  }

  void _handleRefresh() {
    context.read<ReportBloc>().add(FetchReports());
  }

  void _handleReportTap(ReportModel report) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportDetailsScreen(
          reportId: report.id,
          reportTitle: '${report.month} ${report.year}',
        ),
      ),
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
        title: const Text(
          'Analysis Reports',
          style: TextStyle(
            fontFamily: "Poppins",
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _handleRefresh,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg/crystalbg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: BlocBuilder<ReportBloc, ReportState>(
          buildWhen: (previous, current) {
            // Only rebuild when state is relevant to reports list
            // Ignore ReportDetails states
            return current is ReportFetching ||
                current is ReportFetched ||
                current is ReportEmpty ||
                current is ReportError ||
                current is ReportInitial;
          },
          builder: (context, state) {
            if (state is ReportFetching) {
              return LoadingStateWidget(
                currentMessage: _loadingMessages[_currentMessageIndex],
              );
            } else if (state is ReportFetched) {
              return ReportsListWidget(
                reports: state.reports,
                onRefresh: _handleRefresh,
                onReportTap: _handleReportTap,
              );
            } else if (state is ReportEmpty) {
              return EmptyStateWidget(
                onRefresh: _handleRefresh,
              );
            } else if (state is ReportError) {
              return ErrorStateWidget(
                message: state.message,
                onRetry: _handleRefresh,
              );
            }
            // This should only show briefly on initial load
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
}
