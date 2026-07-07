import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/di/service_locator.dart';
import 'package:garuda_user_app/core/widgets/app_scaffold_message.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/forgot_password_bloc.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/forgot_password_event.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/forgot_password_state.dart';
import 'package:garuda_user_app/features/auth/presentation/pages/otp_verification_page.dart';
import 'package:garuda_user_app/features/auth/presentation/widgets/auth_flow_scaffold.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSendOtpPressed(BuildContext context) {
    if (_emailController.text.isEmpty) {
      AppScaffoldMessage.showError(context, 'Please enter your email address');
      return;
    }

    context.read<ForgotPasswordBloc>().add(
      ForgotPasswordRequested(_emailController.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ForgotPasswordBloc>(),
      child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state.status == ForgotPasswordStatus.success) {
            AppScaffoldMessage.showSuccess(
              context,
              state.message ?? 'OTP sent successfully!',
            );
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => OtpVerificationPage(
                  email: _emailController.text.trim(),
                ),
              ),
            );
          } else if (state.status == ForgotPasswordStatus.failure) {
            AppScaffoldMessage.showError(
              context,
              state.errorMessage ?? 'Failed to send OTP',
            );
          }
        },
        builder: (context, state) {
          return AuthFlowScaffold(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const AuthFlowBranding(
                  title: 'Reset Your\nPassword',
                  subtitle: 'Enter your email to receive a reset code.',
                ),
                const SizedBox(height: 48),
                AuthFlowGlassCard(
                  title: 'Forgot Password',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      AuthGlassTextField(
                        controller: _emailController,
                        hint: 'Email Address',
                        icon: Icons.alternate_email_rounded,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 32),
                      AuthPrimaryButton(
                        label: 'Send OTP',
                        isLoading: state.status == ForgotPasswordStatus.loading,
                        onPressed: () => _onSendOtpPressed(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                AuthFlowTextLink(
                  label: 'Back to Login',
                  onPressed: () => context.pop(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
