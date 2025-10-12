import 'package:flutter/material.dart';
import 'package:ai_expense/theme/app_theme.dart';

class HistoryLoadingStateWidget extends StatelessWidget {
  final String message;
  const HistoryLoadingStateWidget({Key? key, required this.message}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 3,
          ),
          const SizedBox(height: 24),
          Text(
            message,
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 16,
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Preparing your insights...',
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
