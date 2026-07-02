import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/availability/availability_bloc.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/cart/cart_bloc.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/shortlist/shortlist_bloc.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/visits/visits_bloc.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/wishlist/wishlist_bloc.dart';
import 'package:garuda_user_app/features/profile/presentation/profile_feature_state.dart';

class ProfileFeatureBlocBuilder extends StatelessWidget {
  const ProfileFeatureBlocBuilder({required this.builder, super.key});

  final Widget Function(BuildContext context, ProfileFeatureState state)
      builder;

  @override
  Widget build(BuildContext context) {
    final state = ProfileFeatureState(
      wishlist: context.watch<WishlistBloc>().state,
      availability: context.watch<AvailabilityBloc>().state,
      cart: context.watch<CartBloc>().state,
      visits: context.watch<VisitsBloc>().state,
      shortlist: context.watch<ShortlistBloc>().state,
    );
    return builder(context, state);
  }
}

ProfileFeatureState profileFeatureStateOf(BuildContext context) {
  return ProfileFeatureState(
    wishlist: context.watch<WishlistBloc>().state,
    availability: context.watch<AvailabilityBloc>().state,
    cart: context.watch<CartBloc>().state,
    visits: context.watch<VisitsBloc>().state,
    shortlist: context.watch<ShortlistBloc>().state,
  );
}
