import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const blueColor = Color(0xFF00627C);
  static const blueColor900 = Color(0xFF0D47A1);
  static const blueColor800 = Color(0xFF1565C0);
  static const blueColor400 = Color(0xFF42A5F5);
  static const errorColor = Colors.redAccent;
  static const whiteColor = Color(0xffffffff);
  static const greyColor = Color(0xFF8F8C8C);
  static const orangeAccent = Color(0xfff25700);
  static const darkorangeAccent = Color(0xff2b2d42);
  static const greenAccent = Color(0xff6BA292);

  static ThemeData defaultTheme = ThemeData.light(useMaterial3: true).copyWith(
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      }),
      colorScheme: ThemeData.light(useMaterial3: true).colorScheme.copyWith(
            primary: orangeAccent,
          ),
      inputDecorationTheme:
          const InputDecorationTheme(focusColor: orangeAccent),
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(backgroundColor: orangeAccent),
      bottomNavigationBarTheme:
          const BottomNavigationBarThemeData(selectedItemColor: orangeAccent),
      textTheme: GoogleFonts.poppinsTextTheme()
          .apply(bodyColor: AppColors.darkorangeAccent));
}
