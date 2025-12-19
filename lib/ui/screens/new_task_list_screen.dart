import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/new_task_list_provider.dart';
import '../providers/task_count_list_provider.dart';
import '../widgets/centered_circular_progress.dart';
import '../providers/task_card.dart';
import 'add_new_task_screen.dart';

class NewTaskListScreen extends StatefulWidget {
  const NewTaskListScreen({super.key});

  @override
  State<NewTaskListScreen> createState() => _NewTaskListScreenState();
}

class _NewTaskListScreenState extends State<NewTaskListScreen> {
  @override
  void initState() {
    super.initState();

    context.read<NewTaskListProvider>().getNewTaskList();
    context.read<TaskCountListProvider>().getTaskCountList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),


            _buildTaskSummary(),

            const SizedBox(height: 8),


            Consumer<NewTaskListProvider>(
              builder: (context, provider, child) {
                if (provider.getNewTaskListInProgress) {
                  return const SizedBox(
                    height: 200,
                    child: CenteredCircularProgress(),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: provider.newTaskList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    return TaskCard(
                      taskModel: provider.newTaskList[index],
                      refreshList: () {

                        context
                            .read<NewTaskListProvider>()
                            .getNewTaskList();
                        context
                            .read<TaskCountListProvider>()
                            .getTaskCountList();
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddNewTaskButton,
        child: const Icon(Icons.add),
      ),
    );
  }


  Future<void> _onTapAddNewTaskButton() async {
    final result = await Navigator.pushNamed(
      context,
      AddNewTaskScreen.name,
    );

    if (result == true) {
      context.read<NewTaskListProvider>().getNewTaskList();
      context.read<TaskCountListProvider>().getTaskCountList();

    }
  }


  Widget _buildTaskSummary() {
    return SizedBox(
      height: 60,
      child: Consumer<TaskCountListProvider>(
        builder: (context, provider, child) {
          if (provider.inProgress) {
            return const CenteredCircularProgress();
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: provider.taskCountList.length,
            itemBuilder: (context, index) {
              final item = provider.taskCountList[index];
              return Card(
                margin: const EdgeInsets.only(left: 8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    children: [
                      Text(
                        item.sum.toString(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        item.id,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
