import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/constants/app_routes.dart';
import 'package:garuda_user_app/core/di/service_locator.dart';
import 'package:garuda_user_app/core/widgets/app_scaffold_message.dart';
import 'package:garuda_user_app/features/auth/domain/entities/signup_credentials.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/signup_bloc.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/signup_event.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/signup_state.dart';
import 'package:garuda_user_app/features/auth/presentation/widgets/auth_flow_scaffold.dart';
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
      AppScaffoldMessage.showError(context, 'Please fill all required fields');
      return;
    }

    context.read<SignupBloc>().add(
      SignupRequested(
        SignupCredentials(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          phone: _phoneController.text.trim(),
          photo: 'https://example.com/profile.jpg',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SignupBloc>(),
      child: BlocConsumer<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state.status == SignupStatus.success) {
            AppScaffoldMessage.showSuccess(
              context,
              'Signup successful! Please login to continue.',
            );
            context.pushReplacement(AppRoutes.login);
          } else if (state.status == SignupStatus.failure) {
            AppScaffoldMessage.showError(
              context,
              state.errorMessage ?? 'Signup failed',
            );
          }
        },
        builder: (context, state) {
          return AuthFlowScaffold(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const AuthFlowBranding(
                  title: 'Start Your\nJourney',
                  subtitle: 'Join thousands of happy land owners.',
                ),
                const SizedBox(height: 40),
                AuthFlowGlassCard(
                  title: 'Create Account',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ProfileImagePicker(
                        selectedImage: _selectedImage,
                        onImageSelected: (image) {
                          setState(() => _selectedImage = image);
                        },
                      ),
                      const SizedBox(height: 24),
                      AuthGlassTextField(
                        controller: _nameController,
                        hint: 'Full Name',
                        icon: Icons.person_outline_rounded,
                      ),
                      const SizedBox(height: 18),
                      AuthGlassTextField(
                        controller: _emailController,
                        hint: 'Email Address',
                        icon: Icons.alternate_email_rounded,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 18),
                      AuthGlassTextField(
                        controller: _phoneController,
                        hint: 'Phone Number',
                        icon: Icons.phone_android_rounded,
                        keyboardType: TextInputType.phone,
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
                      const SizedBox(height: 32),
                      AuthPrimaryButton(
                        label: 'Sign Up',
                        isLoading: state.status == SignupStatus.loading,
                        onPressed: () => _onSignupPressed(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                AuthFlowTextLink(
                  mutedPrefix: 'Already have an account?',
                  label: 'Log In',
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
