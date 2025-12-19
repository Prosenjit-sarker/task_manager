import 'package:flutter/cupertino.dart';

import '../../data/models/task_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';

class CompletedTaskListProvider extends ChangeNotifier {
  bool _getCompletedTaskListInProgress = false;

  String? _errorMessage;

  List<TaskCountModel> _completedTaskList = [];

  bool get getCompletedTaskListInProgress => _getCompletedTaskListInProgress;
  List<TaskCountModel> get completedTaskList => _completedTaskList;
  String? get errorMessage => _errorMessage;

  Future<bool> getCompletedTaskList() async {
    bool isSuccess = false;
    _getCompletedTaskListInProgress = true;
    notifyListeners();

    final NetworkResponse response = await NetworkCaller.getRequest(Urls.completedTasksUrl);
    if (response.isSuccess) {
      List<TaskCountModel> list = [];
      for (Map<String, dynamic> jsonData in response.body['data']) {
        list.add(TaskCountModel.formJson(jsonData));
      }
      _completedTaskList = list;
      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _getCompletedTaskListInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
