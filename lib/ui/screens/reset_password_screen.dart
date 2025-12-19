import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/ui/providers/reset_password_provider.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import '../widgets/snack_bar_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  static const String name = '/reset-password';

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  bool _isNewPassVisible = false;
  bool _isConfirmPassVisible = false;

  late String email;
  late String otp;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
    ModalRoute.of(context)!.settings.arguments as Map<String, String>?;

    email = args?['email'] ?? '';
    otp = args?['otp'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Text(
                  'Reset Password',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Minimum length of password should be more than 8 characters',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 24),

                /// New Password
                TextFormField(
                  controller: _newPassController,
                  obscureText: !_isNewPassVisible,
                  decoration: InputDecoration(
                    hintText: 'New Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isNewPassVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isNewPassVisible = !_isNewPassVisible;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                /// Confirm Password
                TextFormField(
                  controller: _confirmPassController,
                  obscureText: !_isConfirmPassVisible,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPassVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPassVisible = !_isConfirmPassVisible;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// Confirm Button / Loader
                Consumer<ResetPasswordProvider>(
                  builder: (context, provider, child) {
                    return SizedBox(
                      width: double.infinity,
                      child: Visibility(
                        visible: !provider.inProgress,
                        replacement: const Center(
                          child: CircularProgressIndicator(),
                        ),
                        child: FilledButton(
                          onPressed: () =>
                              _onTapConfirmButton(context, provider),
                          child: const Text('Confirm'),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onTapConfirmButton(
      BuildContext context,
      ResetPasswordProvider provider,
      ) async {
    final newPass = _newPassController.text.trim();
    final confirmPass = _confirmPassController.text.trim();

    if (newPass.isEmpty || confirmPass.isEmpty) {
      showSnackBarMessage(context, 'Password fields cannot be empty');
      return;
    }

    if (newPass.length < 8) {
      showSnackBarMessage(
          context, 'Password must be at least 8 characters');
      return;
    }

    if (newPass != confirmPass) {
      showSnackBarMessage(context, 'Passwords do not match');
      return;
    }

    final isSuccess = await provider.resetPassword(
      email: email,
      otp: otp,
      password: newPass,
    );

    if (isSuccess) {
      showSnackBarMessage(context, 'Password reset successful');
      Navigator.pushNamedAndRemoveUntil(
        context,
        SignInScreen.name,
            (route) => false,
      );
    } else {
      showSnackBarMessage(
        context,
        provider.errorMessage ?? 'Password reset failed',
      );
    }
  }

  @override
  void dispose() {
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }
}
