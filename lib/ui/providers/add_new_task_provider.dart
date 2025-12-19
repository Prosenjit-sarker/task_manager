import 'package:flutter/material.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';

class AddNewTaskProvider extends ChangeNotifier {
  bool _inProgress = false;
  String? _errorMessage;

  bool get inProgress => _inProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> addNewTask({
    required String title,
    required String description,
  }) async {
    bool isSuccess = false;

    _inProgress = true;
    notifyListeners();

    final response = await NetworkCaller.postRequest(
      Urls.createNewTaskUrl,
      body: {
        'title': title,
        'description': description,
        'status': 'New',
      },
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
