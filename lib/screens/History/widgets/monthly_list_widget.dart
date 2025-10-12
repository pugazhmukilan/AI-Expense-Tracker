import 'package:flutter/material.dart';
import 'package:ai_expense/models/yearly_summary_model.dart';
import 'package:ai_expense/screens/History/widgets/month_tile_widget.dart';
import 'package:ai_expense/theme/app_theme.dart';

class MonthlyListWidget extends StatelessWidget {
  final List<MonthlySummaryModel> months;
  final Function(MonthlySummaryModel) onMonthSelected;
  const MonthlyListWidget({Key? key, required this.months, required this.onMonthSelected}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 16, 0, 12),
          child: Text(
            'Monthly Breakdown',
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        ...months.map((month) => MonthTileWidget(month: month, onTap: () => onMonthSelected(month))),
      ],
    );
  }
}
