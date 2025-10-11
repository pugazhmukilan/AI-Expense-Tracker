import 'package:ai_expense/models/report_model.dart';
import 'package:ai_expense/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ReportTileWidget extends StatelessWidget {
  final ReportModel report;
  final VoidCallback onTap;

  const ReportTileWidget({
    Key? key,
    required this.report,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: report.isSeen
              ? Colors.grey.withOpacity(0.3)
              : AppColors.tertiary.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: report.isSeen
                  ? [Colors.grey.shade50, Colors.grey.shade100]
                  : [Colors.white, AppColors.tertiary.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              // Icon and Month/Year
              _buildMonthYearIcon(),
              const SizedBox(width: 16),

              // Details
              Expanded(
                child: _buildReportDetails(),
              ),

              // Status Badge
              _buildStatusBadge(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthYearIcon() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: report.isSeen
            ? Colors.grey.withOpacity(0.2)
            : AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            report.month.substring(0, 3).toUpperCase(),
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: report.isSeen ? Colors.grey : Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            report.year.toString(),
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 12,
              color: report.isSeen ? Colors.grey : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${report.month} ${report.year}',
          style: const TextStyle(
            fontFamily: "Poppins",
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Generated on ${_formatDate(report.createdAt)}',
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
        if (report.additionalData != null) ...[
          const SizedBox(height: 4),
          Text(
            'Additional data available',
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 12,
              color: Colors.grey.shade500,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: report.isSeen
            ? Colors.grey.withOpacity(0.2)
            : AppColors.tertiary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            report.isSeen ? Icons.visibility : Icons.fiber_new,
            size: 16,
            color: report.isSeen ? Colors.grey : Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            report.isSeen ? 'Seen' : 'New',
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: report.isSeen ? Colors.grey : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
