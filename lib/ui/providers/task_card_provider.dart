import 'package:flutter/cupertino.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';

class TaskCardProvider extends ChangeNotifier {
  bool _changeStatusInProgress = false;
  bool _deleteTaskInProgress = false;

  bool get changeStatusInProgress => _changeStatusInProgress;
  bool get deleteTaskInProgress => _deleteTaskInProgress;

  Future<bool> changeStatus(String taskId, String status) async {
    _changeStatusInProgress = true;
    notifyListeners();

    final NetworkResponse response = await NetworkCaller.getRequest(Urls.changeTaskStatusUrl(taskId, status));

    _changeStatusInProgress = false;
    notifyListeners();

    return response.isSuccess;
  }

  Future<bool> deleteTask(String taskId) async {
    _deleteTaskInProgress = true;
    notifyListeners();

    final NetworkResponse response = await NetworkCaller.getRequest(Urls.delelteTaskUrl(taskId));

    _deleteTaskInProgress = false;
    notifyListeners();

    return response.isSuccess;
  }
}
