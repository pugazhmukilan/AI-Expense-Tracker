
import 'package:ai_expense/theme/app_theme.dart';
import 'package:flutter/material.dart';

class EditButton extends StatelessWidget {
  final Function func;
  const EditButton({super.key, required this.func});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => func(),
      child: const CircleAvatar(
        backgroundColor: AppColors.tertiary,
        radius: 20,
        child: Icon(
          Icons.edit,
          size: 22,
          color: Colors.white,
        ),
      ),
    );
  }
}