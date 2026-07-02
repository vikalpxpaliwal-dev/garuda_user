import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/app.dart';
import 'package:garuda_user_app/core/di/service_locator.dart';
import 'package:garuda_user_app/core/utils/app_bloc_observer.dart';
import 'package:garuda_user_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _resetStorage = bool.fromEnvironment('RESET_STORAGE');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enable edge-to-edge: make system bars transparent
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarContrastEnforced: false,
    ),
  );

  Bloc.observer = const AppBlocObserver();
  await initializeDependencies();

  if (_resetStorage) {
    await _clearAllLocalStorage();
  }

  runApp(const GarudaApp());
}

Future<void> _clearAllLocalStorage() async {
  await sl<AuthLocalDataSource>().clear();
  await sl<SharedPreferences>().clear();
}
