import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/di/service_locator.dart';
import 'package:garuda_user_app/core/widgets/app_scaffold_message.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/verify_otp_bloc.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/verify_otp_event.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/verify_otp_state.dart';
import 'package:garuda_user_app/features/auth/presentation/pages/reset_password_page.dart';
import 'package:garuda_user_app/features/auth/presentation/widgets/auth_flow_scaffold.dart';
import 'package:go_router/go_router.dart';

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({required this.email, super.key});

  final String email;

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final List<TextEditingController> _controllers =
      List<TextEditingController>.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List<FocusNode>.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onVerifyPressed(BuildContext context) {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length < 6) {
      AppScaffoldMessage.showError(context, 'Please enter the full 6-digit code');
      return;
    }

    context.read<VerifyOtpBloc>().add(
      VerifyOtpRequested(email: widget.email, otp: otp),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<VerifyOtpBloc>(),
      child: BlocConsumer<VerifyOtpBloc, VerifyOtpState>(
        listener: (context, state) {
          if (state.status == VerifyOtpStatus.success) {
            AppScaffoldMessage.showSuccess(
              context,
              state.message ?? 'OTP Verified successfully!',
            );
            final otp = _controllers.map((c) => c.text).join();
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => ResetPasswordPage(
                  email: widget.email,
                  otp: otp,
                ),
              ),
            );
          } else if (state.status == VerifyOtpStatus.failure) {
            AppScaffoldMessage.showError(
              context,
              state.errorMessage ?? 'Verification failed',
            );
          }
        },
        builder: (context, state) {
          return AuthFlowScaffold(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                AuthFlowBranding(
                  badgeIcon: Icons.security_rounded,
                  badgeLabel: 'VERIFICATION',
                  title: 'Enter OTP',
                  subtitle: 'We have sent a 6-digit code to\n${widget.email}',
                ),
                const SizedBox(height: 48),
                AuthFlowGlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List<Widget>.generate(
                          6,
                          (index) => AuthOtpDigitField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            onChanged: (value) => _handleOtpChanged(index, value),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      AuthPrimaryButton(
                        label: 'Verify OTP',
                        isLoading: state.status == VerifyOtpStatus.loading,
                        onPressed: () => _onVerifyPressed(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                AuthFlowTextLink(
                  label: 'Resend Code',
                  onPressed: () => context.pop(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleOtpChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
      return;
    }

    if (index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }
}
