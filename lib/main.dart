import 'package:aida/core/theme/CustomColors.dart';
import 'package:aida/core/theme/app_colors.dart';
import 'package:aida/features/splash/presentation/screen/Splash.dart';
import 'package:aida/features/welcome/presentation/screen/Welcome.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.background,
          onSurface: AppColors.text,
        ),
        extensions: [
          CustomColors(
            lineColor: AppColors.line,
            dropDownLineColor: AppColors.dropDownLine,
          ),
        ],
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.quicksandTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: AppColors.primaryDark,
          secondary: AppColors.secondaryDark,
          surface: AppColors.backgroundDark,
          onSurface: AppColors.textDark,
        ),
        extensions: [
          CustomColors(
            lineColor: AppColors.lineDark,
            dropDownLineColor: AppColors.dropDownLineDark,
          ),
        ],
        scaffoldBackgroundColor: AppColors.backgroundDark,
        textTheme: GoogleFonts.quicksandTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      themeMode: ThemeMode.dark,
      home: Scaffold(
        body: Welcome(),
      ),
    );
  }
}
