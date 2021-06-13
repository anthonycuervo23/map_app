import 'package:flutter/material.dart';

//My imports
import 'package:google_fonts/google_fonts.dart';
import 'package:map_app/core/colors_sizes.dart';

class AppThemes {
  static BuildContext context;
  static final ThemeData defaultTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    accentColor: AppColors.accentColor,
    primarySwatch: Colors.red,
    buttonColor: AppColors.primaryColor,
    appBarTheme: AppBarTheme(
      textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
      elevation: 0,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
    ),
    textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
  );
}
