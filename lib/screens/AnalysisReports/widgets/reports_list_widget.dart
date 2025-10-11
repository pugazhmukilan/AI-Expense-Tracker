import 'package:ai_expense/models/report_model.dart';
import 'package:ai_expense/screens/AnalysisReports/widgets/report_tile_widget.dart';
import 'package:ai_expense/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ReportsListWidget extends StatelessWidget {
  final List<ReportModel> reports;
  final VoidCallback onRefresh;
  final Function(ReportModel) onReportTap;

  const ReportsListWidget({
    Key? key,
    required this.reports,
    required this.onRefresh,
    required this.onReportTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index];
          return ReportTileWidget(
            report: report,
            onTap: () => onReportTap(report),
          );
        },
      ),
    );
  }
}
