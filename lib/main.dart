import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/app.dart';
import 'package:garuda_user_app/core/di/service_locator.dart';
import 'package:garuda_user_app/core/utils/app_bloc_observer.dart';
import 'package:garuda_user_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();
  await initializeDependencies();

  // TODO: TEMPORARY - Clear all storage for testing fresh flow.
  // Remove these lines before committing!
  // await sl<AuthLocalDataSource>().clear();
  // await sl<SharedPreferences>().clear();

  runApp(const GarudaApp());
}
