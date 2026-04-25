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
import 'package:garuda_user_app/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:garuda_user_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:garuda_user_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:garuda_user_app/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/login_bloc.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/signup_bloc.dart';
import 'package:garuda_user_app/features/home/data/datasources/home_local_data_source.dart';
import 'package:garuda_user_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:garuda_user_app/features/home/domain/repositories/home_repository.dart';
import 'package:garuda_user_app/features/home/domain/usecases/get_home_dashboard.dart';
import 'package:garuda_user_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:garuda_user_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:garuda_user_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:garuda_user_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/create_availability_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/create_cart_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/create_final_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/create_payment_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/create_shortlist_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/create_visit_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/delete_final_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/delete_shortlist_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/get_availability_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/get_cart_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/get_finals_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/get_shortlists_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/get_visits_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/get_wishlist_usecase.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:garuda_user_app/features/search/data/datasources/search_remote_data_source.dart';
import 'package:garuda_user_app/features/search/data/repositories/search_repository_impl.dart';
import 'package:garuda_user_app/features/search/domain/repositories/search_repository.dart';
import 'package:garuda_user_app/features/search/domain/usecases/add_to_wishlist_usecase.dart';
import 'package:garuda_user_app/features/search/domain/usecases/get_lands_usecase.dart';
import 'package:garuda_user_app/features/search/domain/usecases/get_locations_usecase.dart';
import 'package:garuda_user_app/features/search/presentation/bloc/search_bloc.dart';
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
    ..registerLazySingleton(() => UpdateProfileUseCase(sl()))
    ..registerLazySingleton(() => DeleteAccountUseCase(sl()))
    ..registerFactory(() => SignupBloc(signupUseCase: sl()))
    ..registerFactory(() => LoginBloc(loginUseCase: sl()))
    ..registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => GetWishlistUseCase(sl()))
    ..registerLazySingleton(() => CreateAvailabilityUseCase(sl()))
    ..registerLazySingleton(() => GetAvailabilityUseCase(sl()))
    ..registerLazySingleton(() => CreateCartUseCase(sl()))
    ..registerLazySingleton(() => GetCartUseCase(sl()))
    ..registerLazySingleton(() => GetVisitsUseCase(sl()))
    ..registerLazySingleton(() => GetShortlistsUseCase(sl()))
    ..registerLazySingleton(() => GetFinalsUseCase(sl()))
    ..registerLazySingleton(() => CreateShortlistUseCase(sl()))
    ..registerLazySingleton(() => DeleteShortlistUseCase(sl()))
    ..registerLazySingleton(() => CreateFinalUseCase(sl()))
    ..registerLazySingleton(() => DeleteFinalUseCase(sl()))
    ..registerLazySingleton(() => CreatePaymentUseCase(sl()))
    ..registerLazySingleton(() => CreateVisitUseCase(sl()))
    ..registerFactory(
      () => ProfileBloc(
        updateProfileUseCase: sl(),
        deleteAccountUseCase: sl(),
        getWishlistUseCase: sl(),
        createAvailabilityUseCase: sl(),
        getAvailabilityUseCase: sl(),
        createCartUseCase: sl(),
        getCartUseCase: sl(),
        getVisitsUseCase: sl(),
        getShortlistsUseCase: sl(),
        getFinalsUseCase: sl(),
        createPaymentUseCase: sl(),
        createShortlistUseCase: sl(),
        deleteShortlistUseCase: sl(),
        createFinalUseCase: sl(),
        deleteFinalUseCase: sl(),
        createVisitUseCase: sl(),
        authBloc: sl(),
      ),
    )

    // Home Feature
    ..registerLazySingleton<HomeLocalDataSource>(HomeLocalDataSourceImpl.new)
    ..registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(localDataSource: sl()),
    )
    ..registerLazySingleton(() => GetHomeDashboard(sl()))
    ..registerFactory(() => HomeBloc(getHomeDashboard: sl()))

    // Search Feature
    ..registerLazySingleton<SearchRemoteDataSource>(
      () => SearchRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<SearchRepository>(
      () => SearchRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => GetLandsUseCase(sl()))
    ..registerLazySingleton(() => AddToWishlistUseCase(sl()))
    ..registerLazySingleton(() => GetLocationsUseCase(sl()))
    ..registerFactory(
      () => SearchBloc(
        getLandsUseCase: sl(),
        addToWishlistUseCase: sl(),
        getLocationsUseCase: sl(),
      ),
    );
}
