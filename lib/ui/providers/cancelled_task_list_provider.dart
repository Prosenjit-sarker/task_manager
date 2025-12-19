import 'package:flutter/cupertino.dart';

import '../../data/models/task_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';

class CancelledTaskListProvider extends ChangeNotifier {
  bool _getCancelledTaskListInProgress = false;

  String? _errorMessage;

  List<TaskCountModel> _cancelledTaskList = [];

  bool get getCancelledTaskListInProgress => _getCancelledTaskListInProgress;
  List<TaskCountModel> get cancelledTaskList => _cancelledTaskList;
  String? get errorMessage => _errorMessage;

  Future<bool> getCancelledTaskList() async {
    bool isSuccess = false;
    _getCancelledTaskListInProgress = true;
    notifyListeners();

    final NetworkResponse response = await NetworkCaller.getRequest(Urls.cancelledTasksUrl);
    if (response.isSuccess) {
      List<TaskCountModel> list = [];
      for (Map<String, dynamic> jsonData in response.body['data']) {
        list.add(TaskCountModel.formJson(jsonData));
      }
      _cancelledTaskList = list;
      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _getCancelledTaskListInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
