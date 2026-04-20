import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/constants/app_routes.dart';
import 'package:garuda_user_app/core/theme/app_colors.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _animationCompleted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 1.0, curve: Curves.easeIn)),
    );

    _controller.forward().then((_) {
      setState(() {
        _animationCompleted = true;
      });
      _checkAuthAndNavigate();
    });

    // Start checking auth as soon as the splash opens
    context.read<AuthBloc>().add(AppStarted());
  }

  void _checkAuthAndNavigate() {
    if (!mounted || !_animationCompleted) return;

    final authState = context.read<AuthBloc>().state;
    if (authState.status == AuthStatus.authenticated) {
      context.go(AppRoutes.home);
    } else if (authState.status == AuthStatus.unauthenticated) {
      context.go(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (_animationCompleted) {
          _checkAuthAndNavigate();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.softBackground,
                  gradient: RadialGradient(
                    center: Alignment(-0.5, -0.4),
                    radius: 1.2,
                    colors: [
                      Color(0xFFFFF4EB),
                      AppColors.softBackground,
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0.6, 0.7),
                    radius: 1.5,
                    colors: [
                      AppColors.primaryOrange.withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 180,
                        height: 180,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(36),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.deepOrange.withValues(alpha: 0.14),
                              blurRadius: 36,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: Image.asset(
                            'assets/images/garuda_logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'GARUDA',
                        style: TextStyle(
                          color: AppColors.ink,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'LANDS',
                        style: TextStyle(
                          color: AppColors.deepOrange.withValues(alpha: 0.8),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
