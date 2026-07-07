import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/di/service_locator.dart';
import 'package:garuda_user_app/core/widgets/app_scaffold_message.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/reset_password_bloc.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/reset_password_event.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/reset_password_state.dart';
import 'package:garuda_user_app/features/auth/presentation/widgets/auth_flow_scaffold.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({
    required this.email,
    required this.otp,
    super.key,
  });

  final String email;
  final String otp;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onResetPressed(BuildContext context) {
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password.isEmpty) {
      AppScaffoldMessage.showError(context, 'Please enter a new password');
      return;
    }
    if (password != confirmPassword) {
      AppScaffoldMessage.showError(context, 'Passwords do not match');
      return;
    }
    if (password.length < 6) {
      AppScaffoldMessage.showError(
        context,
        'Password must be at least 6 characters',
      );
      return;
    }

    context.read<ResetPasswordBloc>().add(
      ResetPasswordRequested(
        email: widget.email,
        otp: widget.otp,
        newPassword: password,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ResetPasswordBloc>(),
      child: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
        listener: (context, state) {
          if (state.status == ResetPasswordStatus.success) {
            AppScaffoldMessage.showSuccess(
              context,
              state.message ?? 'Password reset successfully!',
            );
            while (context.canPop()) {
              context.pop();
            }
          } else if (state.status == ResetPasswordStatus.failure) {
            AppScaffoldMessage.showError(
              context,
              state.errorMessage ?? 'Failed to reset password',
            );
          }
        },
        builder: (context, state) {
          return AuthFlowScaffold(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const AuthFlowBranding(
                  badgeIcon: Icons.lock_reset_rounded,
                  badgeLabel: 'NEW PASSWORD',
                  title: 'Reset Password',
                  subtitle: 'Please enter your new password below.',
                ),
                const SizedBox(height: 48),
                AuthFlowGlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      AuthGlassTextField(
                        controller: _passwordController,
                        hint: 'New Password',
                        icon: Icons.lock_outline_rounded,
                        isPassword: true,
                        isVisible: !_obscurePassword,
                        onVisibilityToggle: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                      const SizedBox(height: 20),
                      AuthGlassTextField(
                        controller: _confirmPasswordController,
                        hint: 'Confirm Password',
                        icon: Icons.lock_reset_rounded,
                        isPassword: true,
                        isVisible: !_obscureConfirm,
                        onVisibilityToggle: () {
                          setState(() => _obscureConfirm = !_obscureConfirm);
                        },
                      ),
                      const SizedBox(height: 32),
                      AuthPrimaryButton(
                        label: 'Reset Password',
                        isLoading: state.status == ResetPasswordStatus.loading,
                        onPressed: () => _onResetPressed(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
