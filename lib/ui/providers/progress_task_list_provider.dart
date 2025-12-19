import 'package:flutter/cupertino.dart';

import '../../data/models/task_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';

class ProgressTaskListProvider extends ChangeNotifier {
  bool _getProgressTaskListInProgress = false;

  String? _errorMessage;

  List<TaskCountModel> _progressTaskList = [];

  bool get getProgressTaskListInProgress => _getProgressTaskListInProgress;
  List<TaskCountModel> get progressTaskList => _progressTaskList;
  String? get errorMessage => _errorMessage;

  Future<bool> getProgressTaskList() async {
    bool isSuccess = false;
    _getProgressTaskListInProgress = true;
    notifyListeners();

    final NetworkResponse response = await NetworkCaller.getRequest(Urls.progressTasksUrl);
    if (response.isSuccess) {
      List<TaskCountModel> list = [];
      for (Map<String, dynamic> jsonData in response.body['data']) {
        list.add(TaskCountModel.formJson(jsonData));
      }
      _progressTaskList = list;
      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _getProgressTaskListInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
