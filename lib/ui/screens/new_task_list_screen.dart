import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/ui/providers/new_task_list_provider.dart';
import '../../data/models/task_count_model.dart';
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
  bool _getTaskCountInProgress = false;

  List<TaskCountModel> _taskCountList = [];

  @override
  void initState() {
    super.initState();
    _getTaskCountList();
    Provider.of<NewTaskListProvider>(context, listen: false).getNewTaskList();

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
            const SizedBox(height: 8),
            Consumer<NewTaskListProvider>(
              builder: (context, newTaskListProvider, child ) {
                return Visibility(
                  visible: newTaskListProvider.getNewTaskListInProgress == false,
                  replacement: SizedBox(
                    height: 200,
                    child: CenteredCircularProgress(),
                  ),
                  child: ListView.separated(
                    itemCount: newTaskListProvider.newTaskList.length,
                    primary: false,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return TaskCard(
                        taskModel: newTaskListProvider.newTaskList[index],
                        refreshList: () {
                          newTaskListProvider.getNewTaskList();
                          _getTaskCountList();
                        },
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 8);
                    },
                  ),
                );
              }
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

  void _onTapAddNewTaskButton() async {
    final result = await Navigator.pushNamed(context, AddNewTaskScreen.name);

    if (result == true) {
      Provider.of<NewTaskListProvider>(context, listen: false)
      .getNewTaskList();     // Task list refresh
      _getTaskCountList();   // Summary counter refresh
    }
  }

  Widget buildTaskSummaryList() {
    return SizedBox(
      height: 60,
      child: Visibility(
        visible: _getTaskCountInProgress == false,
        replacement: CenteredCircularProgress(),
        child: ListView.builder(
          itemCount: _taskCountList.length,
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
                    Text(
                      _taskCountList[index].sum.toString(),
                      style: TextTheme.of(context).titleMedium,
                    ),
                    Text(
                      _taskCountList[index].id,
                      style: TextTheme.of(context).labelSmall,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }


  Future<void> _getTaskCountList() async {
    _getTaskCountInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
      Urls.taskCountUrl,
    );
    if (response.isSuccess) {
      List<TaskCountModel> list = [];
      for (Map<String, dynamic> jsonData in response.body['data']) {
        list.add(TaskCountModel.fromJson(jsonData));
      }
      _taskCountList = list;
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
    _getTaskCountInProgress = false;
    setState(() {});
  }
}
