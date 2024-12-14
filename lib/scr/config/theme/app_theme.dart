import 'package:flutter/material.dart';
import 'package:immobilier_apk/scr/config/app/colors.dart';
import 'package:immobilier_apk/scr/config/app/fonts.dart';

class AppTheme {
  static ThemeData get theme => ThemeData(
  iconTheme: IconThemeData(color: Colors.white),
        fontFamily: Fonts.poppins,
        primaryColor: Colors.pinkAccent,
        textTheme: textTheme,
        appBarTheme: appBarTheme,
        dialogTheme: dialogTheme,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: createMaterialColor(Colors.pinkAccent),
        ).copyWith(
          secondary: Colors.pinkAccent, // Couleur secondaire
        ),
        scaffoldBackgroundColor: AppColors.background,
        dividerColor: Colors.black12,
        primarySwatch: createMaterialColor(Colors.pinkAccent),
      );

  static DialogTheme get dialogTheme {
    return DialogTheme(
        backgroundColor: AppColors.background,
        surfaceTintColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)));
  }

  static AppBarTheme get appBarTheme {
    return AppBarTheme(
        backgroundColor: AppColors.background,
        surfaceTintColor: AppColors.background,
        elevation: .4,
        toolbarHeight: 65,
        iconTheme: IconThemeData(
          color: AppColors.textColor,
        ));
  }

  static TextTheme get textTheme {
    return TextTheme(
        titleSmall: TextStyle(color: AppColors.blue),
        bodySmall: TextStyle(color: AppColors.textColor));
  }
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }

  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}
