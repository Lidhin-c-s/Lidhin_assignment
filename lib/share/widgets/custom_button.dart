import 'package:assignment/share/theme/theme_colors.dart';
import 'package:assignment/share/theme/theme_size.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.callback,
      required this.text,
      required this.selected});
  final String text;
  final VoidCallback callback;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: selected
              ? ThemeColors.primary
              : ThemeColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: selected ? Colors.white : ThemeColors.primary,
              fontSize: ThemeSize.textFieldFontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
