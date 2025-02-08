import 'package:assignment/share/theme/theme_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomSvg extends StatelessWidget {
  const CustomSvg(
      {super.key, required this.assetName, this.width, this.height});

  final String assetName;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      width: width ?? ThemeSize.iconSvgSize,
      height: height ?? ThemeSize.iconSvgSize,
      fit: BoxFit.contain,
    );
  }
}
