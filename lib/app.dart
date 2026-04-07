import 'package:flutter/material.dart';
import 'package:garuda_user_app/core/constants/app_strings.dart';
import 'package:garuda_user_app/core/router/app_router.dart';
import 'package:garuda_user_app/core/theme/app_theme.dart';

class GarudaApp extends StatelessWidget {
  const GarudaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}
