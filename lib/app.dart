import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/constants/app_routes.dart';
import 'package:garuda_user_app/core/constants/app_strings.dart';
import 'package:garuda_user_app/core/di/service_locator.dart';
import 'package:garuda_user_app/core/router/app_router.dart';
import 'package:garuda_user_app/core/theme/app_theme.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/auth_state.dart';

class GarudaApp extends StatelessWidget {
  const GarudaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) =>
            previous.status == AuthStatus.authenticated &&
            current.status == AuthStatus.unauthenticated,
        listener: (context, state) {
          AppRouter.router.go(AppRoutes.login);
        },
        child: MaterialApp.router(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              platformBrightness: Brightness.light,
            ),
            child: child!,
          );
        },
        routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
