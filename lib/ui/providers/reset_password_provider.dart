import 'package:flutter/material.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';

class ResetPasswordProvider extends ChangeNotifier {
  bool _inProgress = false;
  String? _errorMessage;

  bool get inProgress => _inProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String password,
  }) async {
    bool isSuccess = false;

    _inProgress = true;
    notifyListeners();

    final response = await NetworkCaller.postRequest(
      Urls.resetPasswordUrl,
      body: {
        "email": email,
        "OTP": otp,
        "password": password,
      },
      headers: {"Content-Type": "application/json"},
    );

    if (response.isSuccess) {
      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _inProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
