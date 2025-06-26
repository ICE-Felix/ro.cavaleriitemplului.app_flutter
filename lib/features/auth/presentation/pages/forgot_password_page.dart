import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/style/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        ForgotPasswordRequested(email: _emailController.text.trim()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                backgroundColor: AppColors.error,
                duration: const Duration(seconds: 4),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(8),
                action: SnackBarAction(
                  label: 'Dismiss',
                  textColor: Colors.white,
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              ),
            );
          } else if (state is AuthPasswordResetSent) {
            setState(() {
              _emailSent = true;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle_outline, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 4),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(8),
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children:
                      _emailSent
                          ? _buildSuccessContent(context)
                          : _buildFormContent(context),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildFormContent(BuildContext context) {
    return [
      Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            'assets/images/logo/logo.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  FontAwesomeIcons.key,
                  color: AppColors.primary,
                  size: 48,
                ),
              );
            },
          ),
        ),
      ),
      const SizedBox(height: 32),
      Text(
        'Forgot Password?',
        textAlign: TextAlign.center,
        style: Theme.of(
          context,
        ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      Text(
        'Enter your email to reset your password',
        textAlign: TextAlign.center,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
      ),
      const SizedBox(height: 32),
      CustomTextField(
        controller: _emailController,
        labelText: 'Email',
        hintText: 'Enter your email',
        prefixIcon: Icons.email_outlined,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          }
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Please enter a valid email';
          }
          return null;
        },
      ),
      const SizedBox(height: 32),
      CustomButton(
        onPressed:
            context.watch<AuthBloc>().state is AuthLoading
                ? null
                : _resetPassword,
        text: 'Reset Password',
        isLoading: context.watch<AuthBloc>().state is AuthLoading,
      ),
      const SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Remember your password?"),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Sign In'),
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildSuccessContent(BuildContext context) {
    return [
      const Icon(
        FontAwesomeIcons.envelopeCircleCheck,
        color: Colors.green,
        size: 64,
      ),
      const SizedBox(height: 32),
      Text(
        'Email Sent!',
        textAlign: TextAlign.center,
        style: Theme.of(
          context,
        ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 16),
      Text(
        'We\'ve sent a password reset link to ${_emailController.text}',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      const SizedBox(height: 8),
      Text(
        'Please check your email and follow the instructions to reset your password.',
        textAlign: TextAlign.center,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
      ),
      const SizedBox(height: 32),
      CustomButton(
        onPressed: () {
          if (mounted) {
            Navigator.pop(context);
          }
        },
        text: 'Back to Login',
        isLoading: false,
      ),
    ];
  }
}
