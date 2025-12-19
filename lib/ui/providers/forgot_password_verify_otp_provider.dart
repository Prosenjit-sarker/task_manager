import 'package:flutter/material.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';

class ForgotPasswordVerifyOtpProvider extends ChangeNotifier {
  bool _verifyInProgress = false;
  String? _errorMessage;

  bool get verifyInProgress => _verifyInProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> verifyOtp({
    required String email,
    required String otp,
  }) async {
    bool isSuccess = false;

    _verifyInProgress = true;
    notifyListeners();

    final response = await NetworkCaller.getRequest(
      Urls.verifyOtpUrl(email, otp),
    );

    if (response.isSuccess) {
      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _verifyInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
