import 'dart:developer';

import 'package:assignment/share/theme/theme_colors.dart';
import 'package:assignment/share/theme/theme_size.dart';
import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield({
    super.key,
    required this.hintText,
    required this.icon,
    this.onTap,
    this.suffixIcon,
    this.controller,
    this.isReadOnly = false,
  });
  final String hintText;
  final Widget icon;
  final Function()? onTap;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final bool isReadOnly;

  @override
  Widget build(BuildContext context) {
    log("f label ${controller?.text}");
    return TextFormField(
      controller: controller,
      readOnly: isReadOnly,
      onTap: onTap,
      style: TextStyle(
        fontSize: ThemeSize.textFieldFontSize,
        color: controller?.text == "No date" ? Colors.grey : Colors.black,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: icon,
        ),
        prefixIconConstraints: BoxConstraints(
          minWidth: ThemeSize.iconSvgSize,
          minHeight: ThemeSize.iconSvgSize,
        ),
        border: _commonBorder(),
        enabledBorder: _commonBorder(),
        focusedBorder: _commonBorder(),
        suffixIcon: suffixIcon,
        suffixIconConstraints: BoxConstraints(
          minWidth: ThemeSize.iconSvgSize,
          minHeight: ThemeSize.iconSvgSize,
          maxWidth: ThemeSize.iconSvgSize + 24,
        ),
      ),
    );
  }

  OutlineInputBorder _commonBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(
        color: ThemeColors.borderGrey,
      ),
    );
  }
}
