import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nomnom/utils/colors.dart';

class ThemeWrapper extends StatelessWidget {
  final Widget child;
  const ThemeWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarColor: AppColors.whiteColor,
            systemNavigationBarColor: AppColors.whiteColor,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark),
        child: child);
  }
}
