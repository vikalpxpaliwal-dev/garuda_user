import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/constants/app_strings.dart';
import 'package:garuda_user_app/core/theme/app_colors.dart';
import 'package:garuda_user_app/core/utils/context_extensions.dart';
import 'package:garuda_user_app/core/widgets/app_button.dart';
import 'package:garuda_user_app/core/widgets/app_text.dart';
import 'package:garuda_user_app/core/widgets/custom_card.dart';
import 'package:garuda_user_app/core/widgets/common_sliver_app_bar.dart';
import 'package:garuda_user_app/features/home/domain/entities/home_dashboard.dart';
import 'package:garuda_user_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:garuda_user_app/features/home/presentation/bloc/home_event.dart';
import 'package:garuda_user_app/features/home/presentation/bloc/home_state.dart';
import 'package:garuda_user_app/features/home/presentation/widgets/contact_support_card.dart';
import 'package:garuda_user_app/features/home/presentation/widgets/hero_banner_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _onRefresh(BuildContext context) async {
    final bloc = context.read<HomeBloc>()..add(const HomeRequested());
    await bloc.stream.firstWhere((state) => state.status != HomeStatus.loading);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Premium Mesh Gradient Background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.softBackground,
                gradient: RadialGradient(
                  center: Alignment(-0.8, -0.6),
                  radius: 1.2,
                  colors: [
                    Color(0xFFFFF9F2),
                    AppColors.softBackground,
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.9, 0.8),
                  radius: 1.4,
                  colors: [
                    AppColors.primaryOrange.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
          ),
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return RefreshIndicator(
                color: AppColors.deepOrange,
                onRefresh: () => _onRefresh(context),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: <Widget>[
                    const CommonSliverAppBar(),
                    _buildStateSliver(context, state),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStateSliver(BuildContext context, HomeState state) {
    if (state.dashboard != null) {
      return SliverToBoxAdapter(
        child: _PageContainer(
          child: _DashboardContent(dashboard: state.dashboard!),
        ),
      );
    }

    return switch (state.status) {
      HomeStatus.initial || HomeStatus.loading => const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.deepOrange),
        ),
      ),
      HomeStatus.failure => SliverFillRemaining(
        hasScrollBody: false,
        child: _PageContainer(
          child: _ErrorState(
            errorMessage: state.errorMessage ?? AppStrings.unexpectedError,
          ),
        ),
      ),
      HomeStatus.success => const SliverFillRemaining(
        hasScrollBody: false,
        child: SizedBox.shrink(),
      ),
    };
  }
}

class _PageContainer extends StatelessWidget {
  const _PageContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 22, 18, 28),
          child: child,
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.dashboard});

  final HomeDashboard dashboard;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ...dashboard.heroBanners.map(
          (banner) => Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: HeroBannerCard(banner: banner),
          ),
        ),
        const SizedBox(height: 14),
        ContactSupportCard(contactInfo: dashboard.contactInfo),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.errorMessage});

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return Center(
      child: CustomCard(
        color: AppColors.white,
        child: Padding(
          padding: EdgeInsets.all(spacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const AppText(
                'Unable to load the home dashboard',
                variant: AppTextVariant.titleLarge,
              ),
              SizedBox(height: spacing.sm),
              AppText(errorMessage),
              SizedBox(height: spacing.lg),
              AppButton(
                label: AppStrings.retry,
                onPressed: () {
                  context.read<HomeBloc>().add(const HomeRequested());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
