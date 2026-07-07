import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/constants/app_strings.dart';
import 'package:garuda_user_app/core/theme/app_colors.dart';
import 'package:garuda_user_app/core/utils/context_extensions.dart';
import 'package:garuda_user_app/core/widgets/app_button.dart';
import 'package:garuda_user_app/core/widgets/app_content_width.dart';
import 'package:garuda_user_app/core/widgets/app_mesh_background.dart';
import 'package:garuda_user_app/core/widgets/app_page_shell.dart';
import 'package:garuda_user_app/core/widgets/app_text.dart';
import 'package:garuda_user_app/core/widgets/custom_card.dart';
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
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return AppPageShell(
            meshVariant: AppMeshBackgroundVariant.home,
            onRefresh: () => _onRefresh(context),
            slivers: <Widget>[_buildStateSliver(context, state)],
          );
        },
      ),
    );
  }

  Widget _buildStateSliver(BuildContext context, HomeState state) {
    final pagePadding = context.spacing.pageInsets();

    if (state.dashboard != null) {
      return AppContentWidthBox.sliver(
        padding: pagePadding,
        child: _DashboardContent(dashboard: state.dashboard!),
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
        child: AppContentWidthBox(
          padding: pagePadding,
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
            padding: EdgeInsets.only(bottom: context.spacing.xxl),
            child: HeroBannerCard(banner: banner),
          ),
        ),
        SizedBox(height: context.spacing.sm + 2),
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
