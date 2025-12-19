import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/ui/providers/forgot_password_verify_otp_provider.dart';
import 'package:task_manager/ui/screens/reset_password_screen.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import '../widgets/snack_bar_message.dart';

class ForgotPasswordVerifyOtpScreen extends StatefulWidget {
  const ForgotPasswordVerifyOtpScreen({super.key});

  static const String name = '/forgot-password-verify-otp';

  @override
  State<ForgotPasswordVerifyOtpScreen> createState() =>
      _ForgotPasswordVerifyOtpScreenState();
}

class _ForgotPasswordVerifyOtpScreenState
    extends State<ForgotPasswordVerifyOtpScreen> {
  String _otp = '';
  late String email;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    email = ModalRoute.of(context)!.settings.arguments as String;
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
                  'OTP Verification',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'A 6 digit verification code has been sent to $email',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 16),

                /// OTP Field
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  obscuringCharacter: '*',
                  onChanged: (value) {
                    _otp = value;
                  },
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                  ),
                  enableActiveFill: true,
                  backgroundColor: Colors.transparent,
                ),

                const SizedBox(height: 16),

                /// Verify Button / Loader
                Consumer<ForgotPasswordVerifyOtpProvider>(
                  builder: (context, provider, child) {
                    return SizedBox(
                      width: double.infinity,
                      child: Visibility(
                        visible: !provider.verifyInProgress,
                        replacement: const Center(
                          child: CircularProgressIndicator(),
                        ),
                        child: FilledButton(
                          onPressed: () =>
                              _onTapVerifyButton(context, provider),
                          child: const Text('Verify'),
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
                      text: "Have an account? ",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign In',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
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
    );
  }

  Future<void> _onTapVerifyButton(
      BuildContext context,
      ForgotPasswordVerifyOtpProvider provider,
      ) async {
    if (_otp.length != 6) {
      showSnackBarMessage(context, 'Enter 6 digit OTP');
      return;
    }

    final isSuccess = await provider.verifyOtp(
      email: email,
      otp: _otp,
    );

    if (isSuccess) {
      Navigator.pushNamed(
        context,
        ResetPasswordScreen.name,
        arguments: {
          'email': email,
          'otp': _otp,
        },
      );
    } else {
      showSnackBarMessage(
        context,
        provider.errorMessage ?? 'OTP verification failed',
      );
    }
  }

  void _onTapSignInButton() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      SignInScreen.name,
          (route) => false,
    );
  }
}
