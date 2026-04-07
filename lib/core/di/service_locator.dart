import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:garuda_user_app/core/constants/app_constants.dart';
import 'package:garuda_user_app/core/network/api_service.dart';
import 'package:garuda_user_app/core/network/dio_client.dart';
import 'package:garuda_user_app/core/network/interceptors/auth_interceptor.dart';
import 'package:garuda_user_app/core/network/interceptors/logging_interceptor.dart';
import 'package:garuda_user_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:garuda_user_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:garuda_user_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:garuda_user_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:garuda_user_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:garuda_user_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/login_bloc.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/signup_bloc.dart';
import 'package:garuda_user_app/features/home/data/datasources/home_local_data_source.dart';
import 'package:garuda_user_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:garuda_user_app/features/home/domain/repositories/home_repository.dart';
import 'package:garuda_user_app/features/home/domain/usecases/get_home_dashboard.dart';
import 'package:garuda_user_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies({bool reset = false}) async {
  if (reset) {
    await sl.reset();
  }

  if (sl.isRegistered<AuthBloc>()) {
    return;
  }

  // Local Storage
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  const secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  sl.registerLazySingleton<FlutterSecureStorage>(() => secureStorage);

  // Network
  sl
    ..registerLazySingleton<AuthInterceptor>(AuthInterceptor.new)
    ..registerLazySingleton<ApiLoggerInterceptor>(ApiLoggerInterceptor.new)
    ..registerLazySingleton<DioClient>(
      () => DioClient(
        baseUrl: AppConstants.baseUrl,
        authInterceptor: sl(),
        loggerInterceptor: sl(),
      ),
    )
    ..registerLazySingleton<Dio>(() => sl<DioClient>().client)
    ..registerLazySingleton<ApiService>(() => DioApiService(sl()))

    // Auth Feature
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(sl()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
      ),
    )
    ..registerLazySingleton<AuthBloc>(() => AuthBloc(authRepository: sl()))
    ..registerLazySingleton(() => SignupUseCase(sl()))
    ..registerLazySingleton(() => LoginUseCase(sl()))
    ..registerFactory(() => SignupBloc(signupUseCase: sl()))
    ..registerFactory(() => LoginBloc(loginUseCase: sl()))

    // Home Feature
    ..registerLazySingleton<HomeLocalDataSource>(HomeLocalDataSourceImpl.new)
    ..registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(localDataSource: sl()),
    )
    ..registerLazySingleton(() => GetHomeDashboard(sl()))
    ..registerFactory(() => HomeBloc(getHomeDashboard: sl()));
}
