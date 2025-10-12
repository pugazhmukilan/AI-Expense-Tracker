import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_expense/bloc/monthly_details_bloc.dart';
import 'package:ai_expense/bloc/monthly_details_event.dart';
import 'package:ai_expense/bloc/monthly_details_state.dart';
import 'package:ai_expense/screens/MonthlyDetails/widgets/monthly_summary_widget.dart';
import 'package:ai_expense/screens/MonthlyDetails/widgets/monthly_pie_chart_widget.dart';
import 'package:ai_expense/screens/MonthlyDetails/widgets/category_list_widget.dart';
import 'package:ai_expense/theme/app_theme.dart';

class MonthlyDetailsScreen extends StatefulWidget {
  final int month;
  final int year;
  final String monthName;

  const MonthlyDetailsScreen({
    Key? key,
    required this.month,
    required this.year,
    required this.monthName,
  }) : super(key: key);

  @override
  State<MonthlyDetailsScreen> createState() => _MonthlyDetailsScreenState();
}

class _MonthlyDetailsScreenState extends State<MonthlyDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MonthlyDetailsBloc>().add(
          FetchMonthlyDetails(month: widget.month, year: widget.year),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          '${widget.monthName} ${widget.year}',
          style: const TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<MonthlyDetailsBloc, MonthlyDetailsState>(
        builder: (context, state) {
          if (state is MonthlyDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          } else if (state is MonthlyDetailsLoaded) {
            final details = state.monthlyDetails;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MonthlySummaryWidget(monthlyDetails: details),
                  const SizedBox(height: 16),
                  MonthlyPieChartWidget(monthlyDetails: details),
                  const SizedBox(height: 16),
                  CategoryListWidget(monthlyDetails: details),
                ],
              ),
            );
          } else if (state is MonthlyDetailsEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No transactions this month',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is MonthlyDetailsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Error: ${state.message}',
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    color: AppColors.tertiary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        },
      ),
    );
  }
}
