import 'package:ai_expense/theme/app_theme.dart';
import 'package:flutter/material.dart';

class LoadingStateWidget extends StatelessWidget {
  final String currentMessage;

  const LoadingStateWidget({
    Key? key,
    required this.currentMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 4,
          ),
          const SizedBox(height: 24),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Text(
              currentMessage,
              key: ValueKey<String>(currentMessage),
              style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 16,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "We're gathering your monthly expense reports. This may take a few moments.",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 14,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
