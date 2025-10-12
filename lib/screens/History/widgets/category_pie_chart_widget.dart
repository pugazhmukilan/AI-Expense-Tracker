import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ai_expense/models/yearly_summary_model.dart';
import 'package:ai_expense/theme/app_theme.dart';

class CategoryPieChartWidget extends StatelessWidget {
  final YearlySummaryModel summary;
  const CategoryPieChartWidget({Key? key, required this.summary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = summary.yearlyCategories;
    final total = summary.totalYearlyAmount;
    final List<PieChartSectionData> sections = [];
    final List<Color> colors = [
      AppColors.primary,
      AppColors.tertiary,
      AppColors.onPrimary,
      const Color(0xFF9B59B6),
      const Color(0xFF3498DB),
      const Color(0xFF2ECC71),
      const Color(0xFFE74C3C),
      const Color(0xFFF39C12),
      const Color(0xFF1ABC9C),
      const Color(0xFF34495E),
      const Color(0xFFE67E22),
    ];
    int colorIndex = 0;
    categories.forEach((name, cat) {
      final percent = total > 0 ? (cat.totalAmount / total * 100) : 0;
      sections.add(PieChartSectionData(
        color: colors[colorIndex % colors.length],
        value: cat.totalAmount,
        title: '${percent.toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontFamily: "Poppins",
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
      colorIndex++;
    });
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Category Breakdown',
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 40,
                sectionsSpace: 2,
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: categories.keys.map((name) {
              final idx = categories.keys.toList().indexOf(name);
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: colors[idx % colors.length],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    name,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 12,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
