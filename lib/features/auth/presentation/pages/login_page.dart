import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/constants/app_routes.dart';
import 'package:garuda_user_app/core/di/service_locator.dart';
import 'package:garuda_user_app/core/widgets/app_scaffold_message.dart';
import 'package:garuda_user_app/features/auth/domain/entities/login_credentials.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/login_bloc.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/login_event.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/login_state.dart';
import 'package:garuda_user_app/features/auth/presentation/widgets/auth_flow_scaffold.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed(BuildContext context) {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      AppScaffoldMessage.showError(context, 'Please enter email and password');
      return;
    }

    context.read<LoginBloc>().add(
      LoginRequested(
        LoginCredentials(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginBloc>(),
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.success) {
            AppScaffoldMessage.showSuccess(context, 'Login successful!');
            if (state.user != null) {
              context.read<AuthBloc>().add(UserLoggedIn(state.user!));
            }
            context.go(AppRoutes.home);
          } else if (state.status == LoginStatus.failure) {
            AppScaffoldMessage.showError(
              context,
              state.errorMessage ?? 'Login failed',
            );
          }
        },
        builder: (context, state) {
          return AuthFlowScaffold(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const AuthFlowBranding(
                  title: 'Premium Land\nOwnership',
                  subtitle: 'Find your piece of paradise today.',
                ),
                const SizedBox(height: 48),
                AuthFlowGlassCard(
                  title: 'Login to Account',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      AuthGlassTextField(
                        controller: _emailController,
                        hint: 'Email Address',
                        icon: Icons.alternate_email_rounded,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 18),
                      AuthGlassTextField(
                        controller: _passwordController,
                        hint: 'Password',
                        icon: Icons.lock_outline_rounded,
                        isPassword: true,
                        isVisible: _isPasswordVisible,
                        onVisibilityToggle: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      AuthAccentLink(
                        label: 'Forgot Password?',
                        onPressed: () => context.push(AppRoutes.forgotPassword),
                      ),
                      const SizedBox(height: 24),
                      AuthPrimaryButton(
                        label: 'Continue',
                        isLoading: state.status == LoginStatus.loading,
                        onPressed: () => _onLoginPressed(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                AuthFlowTextLink(
                  mutedPrefix: 'New here?',
                  label: 'Create Account',
                  onPressed: () => context.push(AppRoutes.signup),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
