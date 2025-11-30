import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/snack_bar_message.dart';
import 'forgot_password_verify_otp_screen.dart';

class ForgotPasswordEmailScreen extends StatefulWidget {
  const ForgotPasswordEmailScreen({super.key});

  static const String name = '/forgot-password-email';

  @override
  State<ForgotPasswordEmailScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<ForgotPasswordEmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _sending = false;


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
                style: Theme
                    .of(context)
                    .textTheme
                    .titleLarge,
              ),
              Text(
                'A 6 digit verification OTP will be sent to this email address',
                style: Theme
                    .of(context)
                    .textTheme
                    .labelMedium,
              ),
              const SizedBox(height: 8),
              TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(hintText: 'Email')),
              const SizedBox(height: 8),
              Visibility(
                visible: _sending == false,
                replacement: Center(
                  child: CircularProgressIndicator(),
                ),
                child: FilledButton(
                  onPressed: _sending ? null : _onTapSubmitButton,
                  child: Icon(Icons.arrow_circle_right_outlined),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    text: "Have an account? ",
                    children: [
                      TextSpan(
                        style: TextStyle(color: Colors.green),
                        text: 'Sing In',
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


  Future<void> _onTapSubmitButton() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter your email")),
      );
      return;
    }

    setState(() => _sending = true);

    final response = await NetworkCaller.getRequest(
      Urls.forgotPasswordUrl(email),
    );

    setState(() => _sending = false);

    if (response.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP sent to your email")),
      );

      Navigator.pushNamed(
        context,
        ForgotPasswordVerifyOtpScreen.name,
        arguments: email,
      );
    } else{
      showSnackBarMessage(context, response.errorMessage);

    }
  }

  void _onTapSignInButton() {
    Navigator.pop(context);
  }

}