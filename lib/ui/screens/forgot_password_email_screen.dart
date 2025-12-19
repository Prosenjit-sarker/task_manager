import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/ui/providers/forgot_password_email_provider.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'forgot_password_verify_otp_screen.dart';

class ForgotPasswordEmailScreen extends StatefulWidget {
  const ForgotPasswordEmailScreen({super.key});

  static const String name = '/forgot-password-email';

  @override
  State<ForgotPasswordEmailScreen> createState() =>
      _ForgotPasswordEmailScreenState();
}

class _ForgotPasswordEmailScreenState
    extends State<ForgotPasswordEmailScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              const SizedBox(height: 60),
              Text(
                'Your Email Address',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'A 6 digit verification OTP will be sent to this email address',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 8),

              /// Email Field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(hintText: 'Email'),
              ),

              const SizedBox(height: 8),

              /// Button / Loader
              Consumer<ForgotPasswordEmailProvider>(
                builder: (context, provider, child) {
                  return Visibility(
                    visible: !provider.sending,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: FilledButton(
                      onPressed: () =>
                          _onTapSubmitButton(context, provider),
                      child: const Icon(
                        Icons.arrow_circle_right_outlined,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              /// Sign In Text
              Center(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    text: "Have an account? ",
                    children: [
                      TextSpan(
                        style: const TextStyle(color: Colors.green),
                        text: 'Sign In',
                        recognizer: TapGestureRecognizer()
                          ..onTap = _onTapSignInButton,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onTapSubmitButton(
      BuildContext context,
      ForgotPasswordEmailProvider provider,
      ) async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      showSnackBarMessage(context, 'Enter your email');
      return;
    }

    final isSuccess = await provider.sendOtp(email);

    if (isSuccess) {
      showSnackBarMessage(context, 'OTP sent to your email');

      Navigator.pushNamed(
        context,
        ForgotPasswordVerifyOtpScreen.name,
        arguments: email,
      );
    } else {
      showSnackBarMessage(
        context,
        provider.errorMessage ?? 'Something went wrong',
      );
    }
  }

  void _onTapSignInButton() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
