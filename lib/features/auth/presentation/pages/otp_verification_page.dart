import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/di/service_locator.dart';
import 'package:garuda_user_app/core/theme/app_colors.dart';
import 'package:garuda_user_app/core/widgets/app_scaffold_message.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/verify_otp_bloc.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/verify_otp_event.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/verify_otp_state.dart';
import 'package:garuda_user_app/features/auth/presentation/pages/reset_password_page.dart';
import 'package:go_router/go_router.dart';

class OtpVerificationPage extends StatefulWidget {
  final String email;

  const OtpVerificationPage({super.key, required this.email});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onVerifyPressed(BuildContext context) {
    String otp = _controllers.map((c) => c.text).join();
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
      create: (context) => sl<VerifyOtpBloc>(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocConsumer<VerifyOtpBloc, VerifyOtpState>(
          listener: (context, state) {
            if (state.status == VerifyOtpStatus.success) {
              AppScaffoldMessage.showSuccess(
                context,
                state.message ?? 'OTP Verified successfully!',
              );
              String otp = _controllers.map((c) => c.text).join();
              Navigator.of(context).push(
                MaterialPageRoute(
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
            return Stack(
              children: [
                // Premium Background Image (Same as Forgot Password for continuity)
                Positioned.fill(
                  child: Image.network(
                    'https://images.unsplash.com/photo-1500382017468-9049fed747ef?q=80&w=2000&auto=format&fit=crop',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: AppColors.primaryOrange.withValues(alpha: 0.8));
                    },
                  ),
                ),
                // Dark Gradient Overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.6),
                          Colors.black.withValues(alpha: 0.3),
                          Colors.black.withValues(alpha: 0.7),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Branding Section
                            Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(
                                      Icons.security_rounded,
                                      size: 20,
                                      color: Color(0xFFFF9F69),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'VERIFICATION',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            const Text(
                              'Enter OTP',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                height: 1.1,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'We have sent a 6-digit code to\n${widget.email}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 48),
                            // Glassmorphic Card
                            ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                                child: Container(
                                  padding: const EdgeInsets.all(28),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(32),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.25),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: List.generate(6, (index) => _buildOtpBox(index)),
                                      ),
                                      const SizedBox(height: 40),
                                      FilledButton(
                                        onPressed: state.status == VerifyOtpStatus.loading
                                            ? null
                                            : () => _onVerifyPressed(context),
                                        style: FilledButton.styleFrom(
                                          backgroundColor: AppColors.deepOrange,
                                          foregroundColor: AppColors.white,
                                          minimumSize: const Size.fromHeight(60),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          elevation: 0,
                                        ),
                                        child: state.status == VerifyOtpStatus.loading
                                            ? const SizedBox(
                                                height: 24,
                                                width: 24,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2.5,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : const Text(
                                                'Verify OTP',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w900,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 48),
                            TextButton(
                              onPressed: () => context.pop(),
                              child: const Text(
                                'Resend Code',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    return Flexible(
      child: Container(
        height: 55,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        constraints: const BoxConstraints(maxWidth: 48),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _focusNodes[index].hasFocus 
              ? AppColors.primaryOrange 
              : Colors.white.withValues(alpha: 0.15),
            width: 1.5,
          ),
        ),
        child: Center(
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                if (index < 5) {
                  _focusNodes[index + 1].requestFocus();
                } else {
                  _focusNodes[index].unfocus();
                }
              } else {
                if (index > 0) {
                  _focusNodes[index - 1].requestFocus();
                }
              }
            },
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
        ),
      ),
    );
  }
}
