import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/constants/app_routes.dart';
import 'package:garuda_user_app/core/constants/app_strings.dart';
import 'package:garuda_user_app/core/theme/app_colors.dart';
import 'package:garuda_user_app/core/utils/platform_blur.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:go_router/go_router.dart';

class CommonSliverAppBar extends StatelessWidget {
  const CommonSliverAppBar({super.key, this.showSearchAction = true});

  final bool showSearchAction;

  @override
  Widget build(BuildContext context) {
    final useBlur = PlatformBlur.prefersBackdropBlur;
    final scheme = Theme.of(context).colorScheme;
    final barColor = scheme.surface.withValues(
      alpha: useBlur ? 0.72 : 0.92,
    );

    return SliverAppBar(
      pinned: true,
      toolbarHeight: 56,
      backgroundColor: barColor,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: useBlur
          ? ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: PlatformBlur.appBarSigma,
                  sigmaY: PlatformBlur.appBarSigma,
                ),
                child: ColoredBox(color: barColor.withValues(alpha: 0.35)),
              ),
            )
          : null,
      shape: Border(
        bottom: BorderSide(color: AppColors.lightLine.withValues(alpha: 0.4)),
      ),
      titleSpacing: 12,
      title: Row(
        children: <Widget>[
          const Icon(
            Icons.home_work_outlined,
            size: 18,
            color: AppColors.deepOrange,
          ),
          const SizedBox(width: 6),
          Text(
            AppStrings.appName,
            style: const TextStyle(
              color: AppColors.deepOrange,
              fontSize: 17,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        if (showSearchAction)
          IconButton(
            onPressed: () => context.go(AppRoutes.search),
            icon: const Icon(
              Icons.search_rounded,
              size: 20,
              color: AppColors.ink,
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () => context.go(AppRoutes.profile),
            child: Container(
              padding: const EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.forestGreen.withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final initial = state.user?.name.isNotEmpty == true
                      ? state.user!.name[0].toUpperCase()
                      : 'U';

                  return CircleAvatar(
                    radius: 12,
                    backgroundColor: const Color(0xFFC8E6C9),
                    child: Text(
                      initial,
                      style: const TextStyle(
                        color: AppColors.forestGreen,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
