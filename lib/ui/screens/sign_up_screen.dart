import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/ui/providers/sign_up_provider.dart';

import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const String name = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  const SizedBox(height: 60),
                  Text(
                    'Join with Us',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),

                  /// Email
                  TextFormField(
                    controller: _emailTEController,
                    decoration: const InputDecoration(hintText: 'Email'),
                    validator: (value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter a valid email';
                      }
                      if (!EmailValidator.validate(value!)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),

                  /// First name
                  TextFormField(
                    controller: _firstNameTEController,
                    decoration: const InputDecoration(hintText: 'First name'),
                    validator: (value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your first name';
                      }
                      return null;
                    },
                  ),

                  /// Last name
                  TextFormField(
                    controller: _lastNameTEController,
                    decoration: const InputDecoration(hintText: 'Last name'),
                    validator: (value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your last name';
                      }
                      return null;
                    },
                  ),

                  /// Mobile
                  TextFormField(
                    controller: _mobileTEController,
                    decoration: const InputDecoration(hintText: 'Mobile'),
                    validator: (value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your mobile number';
                      }
                      return null;
                    },
                  ),

                  /// Password
                  TextFormField(
                    controller: _passwordTEController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Enter your password';
                      }
                      if (value!.length < 7) {
                        return 'Enter a password more than 6 letters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 8),

                  /// 🔹 Sign Up Button / Loader
                  Consumer<SignUpProvider>(
                    builder: (context, provider, child) {
                      return Visibility(
                        visible: !provider.signUpInProgress,
                        replacement: const Center(
                          child: CircularProgressIndicator(),
                        ),
                        child: FilledButton(
                          onPressed: () => _onTapSignUpButton(provider),
                          child: const Icon(
                              Icons.arrow_circle_right_outlined),
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
                        text: "Already have an account? ",
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
        ),
      ),
    );
  }

  /// 🔹 Button Action
  Future<void> _onTapSignUpButton(SignUpProvider provider) async {
    if (!_formKey.currentState!.validate()) return;

    final isSuccess = await provider.signUp(
      email: _emailTEController.text.trim(),
      firstName: _firstNameTEController.text.trim(),
      lastName: _lastNameTEController.text.trim(),
      mobile: _mobileTEController.text.trim(),
      password: _passwordTEController.text,
    );

    if (isSuccess) {
      _clearTextField();
      showSnackBarMessage(
        context,
        'Registration Successful! Please Sign In.',
      );
    } else {
      showSnackBarMessage(
        context,
        provider.errorMessage ?? 'Registration failed',
      );
    }
  }

  void _onTapSignInButton() {
    Navigator.pop(context);
  }

  void _clearTextField() {
    _emailTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _mobileTEController.clear();
    _passwordTEController.clear();
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
