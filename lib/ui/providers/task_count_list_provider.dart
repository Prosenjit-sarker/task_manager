import 'package:flutter/material.dart';
import '../../data/models/task_count_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';

class TaskCountListProvider extends ChangeNotifier {
  bool _inProgress = false;
  String? _errorMessage;
  List<TaskCountModel> _taskCountList = [];

  bool get inProgress => _inProgress;
  List<TaskCountModel> get taskCountList => _taskCountList;
  String? get errorMessage => _errorMessage;

  Future<void> getTaskCountList() async {
    _inProgress = true;
    notifyListeners();

    final response = await NetworkCaller.getRequest(Urls.taskCountUrl);

    if (response.isSuccess) {
      _taskCountList = (response.body['data'] as List)
          .map((e) => TaskCountModel.fromJson(e))
          .toList();
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }

    _inProgress = false;
    notifyListeners();
  }
}
