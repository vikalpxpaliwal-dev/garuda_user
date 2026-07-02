import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/di/service_locator.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/availability/availability_bloc.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/availability/availability_event.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/cart/cart_bloc.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/shortlist/shortlist_bloc.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/shortlist/shortlist_event.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/visits/visits_bloc.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/wishlist/wishlist_bloc.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/wishlist/wishlist_event.dart';

/// Provides all profile-related blocs at the shell branch level so
/// [ProfilePage] and [EditProfilePage] share the same instances.
class ProfileScope extends StatelessWidget {
  const ProfileScope({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(create: (_) => sl<ProfileBloc>()),
        BlocProvider<WishlistBloc>(
          create: (_) => sl<WishlistBloc>()..add(const WishlistRequested()),
        ),
        BlocProvider<AvailabilityBloc>(
          create: (_) =>
              sl<AvailabilityBloc>()..add(const GetAvailabilitiesRequested()),
        ),
        BlocProvider<CartBloc>(create: (_) => sl<CartBloc>()),
        BlocProvider<VisitsBloc>(create: (_) => sl<VisitsBloc>()),
        BlocProvider<ShortlistBloc>(
          create: (_) => sl<ShortlistBloc>()..add(const GetFinalsRequested()),
        ),
      ],
      child: child,
    );
  }
}
