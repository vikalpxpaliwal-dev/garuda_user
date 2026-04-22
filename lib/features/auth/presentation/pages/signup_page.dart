import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/constants/app_routes.dart';
import 'package:garuda_user_app/core/di/service_locator.dart';
import 'package:garuda_user_app/core/theme/app_colors.dart';
import 'package:garuda_user_app/core/widgets/app_scaffold_message.dart';
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
    if (isSuccess) {
      AppScaffoldMessage.showSuccess(context, message);
    } else {
      AppScaffoldMessage.showError(context, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SignupBloc>(),
      child: Scaffold(
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
                // Premium Background Image
                Positioned.fill(
                  child: Image.network(
                    'https://images.unsplash.com/photo-1500382017468-9049fed747ef?q=80&w=2000&auto=format&fit=crop',
                    fit: BoxFit.cover,
                  ),
                ),
                // Dark Gradient Overlay for readability
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
                                      Icons.landscape_rounded,
                                      size: 20,
                                      color: Color(0xFFFF9F69),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'GARUDA LANDS',
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
                              'Start Your\nJourney',
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
                              'Join thousands of happy land owners.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 40),
                            // Glassmorphic Signup Card
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
                                      const Text(
                                        'Create Account',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      ProfileImagePicker(
                                        selectedImage: _selectedImage,
                                        onImageSelected: (image) {
                                          setState(() {
                                            _selectedImage = image;
                                          });
                                        },
                                      ),
                                      const SizedBox(height: 24),
                                      _buildTextField(
                                        controller: _nameController,
                                        hint: 'Full Name',
                                        icon: Icons.person_outline_rounded,
                                      ),
                                      const SizedBox(height: 18),
                                      _buildTextField(
                                        controller: _emailController,
                                        hint: 'Email Address',
                                        icon: Icons.alternate_email_rounded,
                                        keyboardType: TextInputType.emailAddress,
                                      ),
                                      const SizedBox(height: 18),
                                      _buildTextField(
                                        controller: _phoneController,
                                        hint: 'Phone Number',
                                        icon: Icons.phone_android_rounded,
                                        keyboardType: TextInputType.phone,
                                      ),
                                      const SizedBox(height: 18),
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
                                      const SizedBox(height: 32),
                                      FilledButton(
                                        onPressed: state.status == SignupStatus.loading
                                            ? null
                                            : () => _onSignupPressed(context),
                                        style: FilledButton.styleFrom(
                                          backgroundColor: AppColors.deepOrange,
                                          foregroundColor: AppColors.white,
                                          minimumSize: const Size.fromHeight(60),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          elevation: 0,
                                        ),
                                        child: state.status == SignupStatus.loading
                                            ? const SizedBox(
                                                height: 24,
                                                width: 24,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2.5,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : const Text(
                                                'Sign Up',
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
                            const SizedBox(height: 32),
                            // Login Link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => context.pop(),
                                  child: const Text(
                                    'Log In',
                                    style: TextStyle(
                                      color: Colors.white,
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
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 1.2,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !isVisible,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, size: 20, color: Colors.white.withValues(alpha: 0.5)),
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: onVisibilityToggle,
                  icon: Icon(
                    isVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                    size: 20,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                )
              : null,
          hintStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.3),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        ),
      ),
    );
  }
}

