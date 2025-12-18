import 'package:flutter/cupertino.dart';

import '../../data/models/task_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';

class NewTaskListProvider extends ChangeNotifier {
  bool _getNewTaskListInProgress = false;

  String? _errorMessage;

  List<TaskModel> _newTaskList = [];

  bool get getNewTaskListInProgress => _getNewTaskListInProgress;
  List<TaskModel> get newTaskList => _newTaskList;
  String? get errorMessage => _errorMessage;

  Future<bool> getNewTaskList() async {
    bool isSuccess = false;
    _getNewTaskListInProgress = true;
    notifyListeners();

    final NetworkResponse response = await NetworkCaller.getRequest(
      Urls.newTasksUrl,
    );
    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.body['data']) {
        list.add(TaskModel.formJson(jsonData));
      }
      _newTaskList = list;
      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _getNewTaskListInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
