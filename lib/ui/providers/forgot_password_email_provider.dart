import 'package:flutter/material.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';

class ForgotPasswordEmailProvider extends ChangeNotifier {
  bool _sending = false;
  String? _errorMessage;

  bool get sending => _sending;
  String? get errorMessage => _errorMessage;

  Future<bool> sendOtp(String email) async {
    bool isSuccess = false;

    _sending = true;
    notifyListeners();

    final response = await NetworkCaller.getRequest(
      Urls.forgotPasswordUrl(email),
    );

    if (response.isSuccess) {
      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _sending = false;
    notifyListeners();

    return isSuccess;
  }
}
