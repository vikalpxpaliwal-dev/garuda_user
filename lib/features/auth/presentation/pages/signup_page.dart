import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/constants/app_routes.dart';
import 'package:garuda_user_app/core/di/service_locator.dart';
import 'package:garuda_user_app/core/theme/app_colors.dart';
import 'package:garuda_user_app/core/widgets/custom_card.dart';
import 'package:garuda_user_app/features/auth/data/models/signup_request_model.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/signup_bloc.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/signup_event.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/signup_state.dart';
import 'package:garuda_user_app/features/auth/presentation/widgets/profile_image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  XFile? _selectedImage;
  
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onSignupPressed(BuildContext context) {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      _showScaffoldMessage(
        context: context,
        message: 'Please fill all required fields',
        isSuccess: false,
      );
      return;
    }

    final request = SignupRequestModel(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      phone: _phoneController.text.trim(),
      // In a real app, we would upload the file here and get a URL.
      // For now, we use a placeholder as the API expects a String URL.
      photo: 'https://example.com/profile.jpg',
    );

    context.read<SignupBloc>().add(SignupRequested(request));
  }

  void _showScaffoldMessage({
    required BuildContext context,
    required String message,
    required bool isSuccess,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    final accentColor = isSuccess ? const Color(0xFF2E7D32) : const Color(0xFFC62828);
    final icon = isSuccess ? Icons.check_circle_rounded : Icons.error_rounded;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          padding: EdgeInsets.zero,
          elevation: 0,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.transparent,
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.98),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.25),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.ink.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  height: 26,
                  width: 26,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Icon(icon, size: 16, color: accentColor),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SignupBloc>(),
      child: Scaffold(
        backgroundColor: AppColors.softBackground,
        body: BlocConsumer<SignupBloc, SignupState>(
          listener: (context, state) {
            if (state.status == SignupStatus.success) {
              _showScaffoldMessage(
                context: context,
                message: 'Signup successful! Please login to continue.',
                isSuccess: true,
              );
              context.pushReplacement(AppRoutes.login);
            } else if (state.status == SignupStatus.failure) {
              _showScaffoldMessage(
                context: context,
                message: state.errorMessage ?? 'Signup failed',
                isSuccess: false,
              );
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                // Mesh Background
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment(-0.8, -0.6),
                        radius: 1.2,
                        colors: [
                          Color(0xFFFFF9F2),
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
                        center: const Alignment(0.9, 0.8),
                        radius: 1.4,
                        colors: [
                          AppColors.primaryOrange.withValues(alpha: 0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: AppColors.white.withValues(alpha: 0.9),
                                  width: 1.2,
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.home_work_rounded,
                                    size: 18,
                                    color: AppColors.deepOrange,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'GARUDA STAYS',
                                    style: TextStyle(
                                      color: AppColors.ink,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Join Garuda',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.ink,
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Create your account to start your stay journey.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.mutedText,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 40),
                            CustomCard(
                              borderRadius: BorderRadius.circular(28),
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.white.withValues(alpha: 0.8),
                                  AppColors.white.withValues(alpha: 0.4),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border: Border.all(
                                color: AppColors.white.withValues(alpha: 0.8),
                                width: 1.2,
                              ),
                              padding: const EdgeInsets.all(24),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(28),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      const Text(
                                        'Create Account',
                                        style: TextStyle(
                                          color: AppColors.ink,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Enter your details to set up your profile.',
                                        style: TextStyle(
                                          color: AppColors.mutedText,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                      ProfileImagePicker(
                                        selectedImage: _selectedImage,
                                        onImageSelected: (image) {
                                          setState(() {
                                            _selectedImage = image;
                                          });
                                        },
                                      ),
                                      const SizedBox(height: 24),
                                      _buildFieldLabel('Full Name'),
                                      const SizedBox(height: 8),
                                      _buildTextField(
                                        controller: _nameController,
                                        hint: 'Enter your full name',
                                        icon: Icons.person_outline_rounded,
                                      ),
                                      const SizedBox(height: 16),
                                      _buildFieldLabel('Email'),
                                      const SizedBox(height: 8),
                                      _buildTextField(
                                        controller: _emailController,
                                        hint: 'Enter your email',
                                        icon: Icons.email_outlined,
                                        keyboardType: TextInputType.emailAddress,
                                      ),
                                      const SizedBox(height: 16),
                                      _buildFieldLabel('Phone Number'),
                                      const SizedBox(height: 8),
                                      _buildTextField(
                                        controller: _phoneController,
                                        hint: 'Enter your phone number',
                                        icon: Icons.phone_android_outlined,
                                        keyboardType: TextInputType.phone,
                                      ),
                                      const SizedBox(height: 16),
                                      _buildFieldLabel('Password'),
                                      const SizedBox(height: 8),
                                      _buildTextField(
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
                                      const SizedBox(height: 24),
                                      FilledButton(
                                        onPressed: state.status == SignupStatus.loading
                                            ? null
                                            : () => _onSignupPressed(context),
                                        style: FilledButton.styleFrom(
                                          backgroundColor: AppColors.deepOrange,
                                          foregroundColor: AppColors.white,
                                          minimumSize: const Size.fromHeight(56),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          elevation: 8,
                                          shadowColor: AppColors.deepOrange.withValues(alpha: 0.4),
                                        ),
                                        child: state.status == SignupStatus.loading
                                            ? const SizedBox(
                                                height: 24,
                                                width: 24,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : const Text(
                                                'Create Account',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w900,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                      ),
                                      const SizedBox(height: 14),
                                      Row(
                                        children: const [
                                          Icon(
                                            Icons.verified_user_rounded,
                                            size: 16,
                                            color: AppColors.mutedText,
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'Your information stays private and encrypted.',
                                              style: TextStyle(
                                                color: AppColors.mutedText,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                    color: AppColors.mutedText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => context.pop(),
                                  child: const Text(
                                    'Log In',
                                    style: TextStyle(
                                      color: AppColors.deepOrange,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ],
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isVisible = false,
    VoidCallback? onVisibilityToggle,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.white,
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !isVisible,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: AppColors.ink,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, size: 20, color: AppColors.mutedText),
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: onVisibilityToggle,
                  icon: Icon(
                    isVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                    size: 20,
                    color: AppColors.mutedText,
                  ),
                )
              : null,
          hintStyle: const TextStyle(
            color: AppColors.mutedText,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.ink,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

