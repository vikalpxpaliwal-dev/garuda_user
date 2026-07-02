import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/di/service_locator.dart';
import 'package:garuda_user_app/features/search/presentation/bloc/search_bloc.dart';
import 'package:garuda_user_app/features/search/presentation/bloc/search_event.dart';

/// Provides [SearchBloc] at the search shell branch so list and detail routes
/// share the same instance.
class SearchScope extends StatelessWidget {
  const SearchScope({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (_) => sl<SearchBloc>()..add(const LoadWishlistedLandIdsEvent()),
      child: child,
    );
  }
}
