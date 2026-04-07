import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/constants/app_routes.dart';
import 'package:garuda_user_app/core/di/service_locator.dart';
import 'package:garuda_user_app/core/widgets/app_shell_scaffold.dart';
import 'package:garuda_user_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:garuda_user_app/features/home/presentation/bloc/home_event.dart';
import 'package:garuda_user_app/features/home/presentation/pages/home_page.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:garuda_user_app/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:garuda_user_app/features/profile/presentation/pages/profile_page.dart';
import 'package:garuda_user_app/features/auth/presentation/pages/login_page.dart';
import 'package:garuda_user_app/features/auth/presentation/pages/signup_page.dart';
import 'package:garuda_user_app/features/search/presentation/pages/search_listing_detail_page.dart';
import 'package:garuda_user_app/features/search/presentation/pages/search_page.dart';
import 'package:garuda_user_app/features/splash/presentation/pages/splash_page.dart';
import 'package:go_router/go_router.dart';

final class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShellScaffold(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.home,
                pageBuilder: (context, state) {
                  return NoTransitionPage<void>(
                    child: BlocProvider<HomeBloc>(
                      create: (_) => sl<HomeBloc>()..add(const HomeRequested()),
                      child: const HomePage(),
                    ),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.search,
                pageBuilder: (context, state) {
                  return const NoTransitionPage<void>(child: SearchPage());
                },
                routes: <RouteBase>[
                  GoRoute(
                    path: '${AppRoutes.searchDetails}/:index',
                    pageBuilder: (context, state) {
                      final index =
                          int.tryParse(state.pathParameters['index'] ?? '') ??
                          0;

                      return NoTransitionPage<void>(
                        child: SearchListingDetailPage(listingIndex: index),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.profile,
                pageBuilder: (context, state) {
                  return const NoTransitionPage<void>(child: ProfilePage());
                },
                routes: [
                  GoRoute(
                    path: AppRoutes.editProfile,
                    pageBuilder: (context, state) {
                      return NoTransitionPage<void>(
                        child: BlocProvider<ProfileBloc>(
                          create: (context) => sl<ProfileBloc>(),
                          child: const EditProfilePage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
