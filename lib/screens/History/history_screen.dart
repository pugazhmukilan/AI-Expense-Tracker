import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_expense/bloc/history_bloc.dart';
import 'package:ai_expense/bloc/history_event.dart';
import 'package:ai_expense/bloc/history_state.dart';
import 'package:ai_expense/models/yearly_summary_model.dart';
import 'package:ai_expense/screens/History/widgets/yearly_summary_widget.dart';
import 'package:ai_expense/screens/History/widgets/category_pie_chart_widget.dart';
import 'package:ai_expense/screens/History/widgets/monthly_list_widget.dart';
import 'package:ai_expense/screens/History/widgets/loading_state_widget.dart';
import 'package:ai_expense/screens/History/widgets/error_state_widget.dart';
import 'package:ai_expense/screens/History/widgets/empty_state_widget.dart';
import 'package:ai_expense/screens/MonthlyDetails/monthly_details_screen.dart';
import 'package:ai_expense/theme/app_theme.dart';
// ...existing code...

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryBloc>().add(FetchYearlySummary());
  }

  void _refresh() {
    context.read<HistoryBloc>().add(RefreshYearlySummary());
  }

  void _onMonthSelected(MonthlySummaryModel month) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MonthlyDetailsScreen(
          month: month.month,
          year: month.year,
          monthName: month.monthName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Transaction History', style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
          ),
        ],
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        buildWhen: (previous, current) {
          // Only rebuild when state actually changes for history
          // Don't rebuild if we're just returning from another screen
          return current is HistoryLoading ||
              current is HistoryLoaded ||
              current is HistoryEmpty ||
              current is HistoryError ||
              current is HistoryInitial;
        },
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const HistoryLoadingStateWidget(message: 'Loading your transaction history...');
          } else if (state is HistoryLoaded) {
            final summary = state.yearlySummary;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  YearlySummaryWidget(summary: summary),
                  CategoryPieChartWidget(summary: summary),
                  MonthlyListWidget(
                    months: summary.monthlyBreakdown,
                    onMonthSelected: _onMonthSelected,
                  ),
                ],
              ),
            );
          } else if (state is HistoryEmpty) {
            return HistoryEmptyStateWidget(onRefresh: _refresh);
          } else if (state is HistoryError) {
            return HistoryErrorStateWidget(message: state.message, onRetry: _refresh);
          }
          return const HistoryLoadingStateWidget(message: 'Initializing...');
        },
      ),
    );
  }
}
