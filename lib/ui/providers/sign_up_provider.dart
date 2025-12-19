import 'package:flutter/material.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';

class SignUpProvider extends ChangeNotifier {
  bool _signUpInProgress = false;
  String? _errorMessage;

  bool get signUpInProgress => _signUpInProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> signUp({
    required String email,
    required String firstName,
    required String lastName,
    required String mobile,
    required String password,
  }) async {
    bool isSuccess = false;

    _signUpInProgress = true;
    notifyListeners();

    final Map<String, dynamic> requestBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
      "password": password,
    };

    final NetworkResponse response = await NetworkCaller.postRequest(
      Urls.registrationUrl,
      body: requestBody,
    );

    if (response.isSuccess) {
      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _signUpInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
