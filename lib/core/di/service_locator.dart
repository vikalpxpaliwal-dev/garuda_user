import 'package:dio/dio.dart';
import 'package:garuda_user_app/core/constants/app_constants.dart';
import 'package:garuda_user_app/core/network/api_service.dart';
import 'package:garuda_user_app/core/network/dio_client.dart';
import 'package:garuda_user_app/core/network/interceptors/auth_interceptor.dart';
import 'package:garuda_user_app/core/network/interceptors/logging_interceptor.dart';
import 'package:garuda_user_app/features/home/data/datasources/home_local_data_source.dart';
import 'package:garuda_user_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:garuda_user_app/features/home/domain/repositories/home_repository.dart';
import 'package:garuda_user_app/features/home/domain/usecases/get_home_dashboard.dart';
import 'package:garuda_user_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies({bool reset = false}) async {
  if (reset) {
    await sl.reset();
  }

  if (sl.isRegistered<HomeBloc>()) {
    return;
  }

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
    ..registerLazySingleton<HomeLocalDataSource>(HomeLocalDataSourceImpl.new)
    ..registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(localDataSource: sl()),
    )
    ..registerLazySingleton(() => GetHomeDashboard(sl()))
    ..registerFactory(() => HomeBloc(getHomeDashboard: sl()));
}
