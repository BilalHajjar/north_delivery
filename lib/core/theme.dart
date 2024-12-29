import 'package:delivary/core/colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
        fontFamily: 'FontApp',
        scaffoldBackgroundColor: Color(0xfff3f2f2),
        drawerTheme: DrawerThemeData(backgroundColor: AppColors.whiteColor),
        colorSchemeSeed: AppColors.primaColor,
        appBarTheme: AppBarTheme(centerTitle: true,backgroundColor: AppColors.primaColor),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(fontSize: 12, color: AppColors.grey),
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(
                color: AppColors.error,
              )),
          // enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
          // enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(
                color: AppColors.primaColor,
              )), focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(
                color: AppColors.primaColor,
              )),
        ));
  }
}
