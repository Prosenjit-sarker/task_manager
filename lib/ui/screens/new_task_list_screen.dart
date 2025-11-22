import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/service/network_caller.dart';

import '../../data/utils/urls.dart';
import '../widgets/centered_circular_progress.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';
import 'add_new_task_screen.dart';

class NewTaskListScreen extends StatefulWidget {
  const NewTaskListScreen({super.key});

  @override
  State<NewTaskListScreen> createState() => _NewTaskListScreenState();
}

class _NewTaskListScreenState extends State<NewTaskListScreen> {
  bool _getNewTaskListInProgress = false;
  List<TaskModel> _newTaskList = [];
  @override
  void initState() {
    super.initState();
    _getNewTaskList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          spacing: 8,
          children: [
            const SizedBox(),
            buildTaskSummaryList(),
            Visibility(
              visible: _getNewTaskListInProgress == false,
              replacement: SizedBox(
                height: 200,
                  child: CenteredCircularProgress(),
              ),
              child: ListView.separated(
                itemCount: _newTaskList.length,
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return TaskCard(taskModel: _newTaskList[index]);
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 8);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddNewTaskButton,
        child: Icon(Icons.add),
      ),
    );
  }

  void _onTapAddNewTaskButton() {
    Navigator.pushNamed(context, AddNewTaskScreen.name);
  }

  Widget buildTaskSummaryList() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        itemCount: 10,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Card(
            elevation: 0,
            color: Colors.white,
            margin: EdgeInsets.only(left: 8),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Column(
                children: [
                  Text('12', style: TextTheme.of(context).titleMedium),
                  Text('New', style: TextTheme.of(context).labelSmall),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _getNewTaskList() async {
    _getNewTaskListInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
      Urls.newTasksUrl,
    );
    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.body['data']) {
        list.add(TaskModel.formJson(jsonData));
      }
      _newTaskList = list;
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
    _getNewTaskListInProgress = false;
    setState(() {});
  }
}

