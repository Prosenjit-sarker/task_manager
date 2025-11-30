import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';
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
  bool _setpasswordInProgress = false;

  late String email;
  late String otp;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>?;
    if (args != null) {
      email = args['email'] ?? '';
      otp = args['otp'] ?? '';
    } else {
      email = '';
      otp = '';
    }
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
                Text('Reset Password', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  'Minimum length of password should be more than 8 characters',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _newPassController,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: 'New Password'),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmPassController,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: 'Confirm Password'),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: Visibility(
                    visible: !_setpasswordInProgress,
                    replacement: const Center(child: CircularProgressIndicator()),
                    child: FilledButton(
                      onPressed: _onTapConfirmButton,
                      child: const Text('Confirm'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onTapConfirmButton() async {
    final newPass = _newPassController.text.trim();
    final confirmPass = _confirmPassController.text.trim();

    if (newPass.isEmpty || confirmPass.isEmpty) {
      showSnackBarMessage(context, "Password fields cannot be empty");
      return;
    }

    if (newPass.length < 8) {
      showSnackBarMessage(context, "Password must be at least 8 characters");
      return;
    }

    if (newPass != confirmPass) {
      showSnackBarMessage(context, "Passwords do not match");
      return;
    }

    setState(() {
      _setpasswordInProgress = true;
    });

    final response = await NetworkCaller.postRequest(
      Urls.resetPasswordUrl,
      body: {
        "email": email,
        "OTP": otp,
        "password": newPass,
      },
      headers: {"Content-Type": "application/json"},
    );

    setState(() {
      _setpasswordInProgress = false;
    });

    if (response.isSuccess) {
      showSnackBarMessage(context, "Password reset successful");
      Navigator.pushNamedAndRemoveUntil(context, SignInScreen.name, (p) => false);
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
  }

  @override
  void dispose() {
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }
}
