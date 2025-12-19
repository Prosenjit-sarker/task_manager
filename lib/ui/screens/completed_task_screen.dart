import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/completed_task_list_provider.dart';
import '../widgets/centered_circular_progress.dart';
import '../widgets/task_card.dart';

class CompletedTaskListScreen extends StatefulWidget {
  const CompletedTaskListScreen({super.key});

  @override
  State<CompletedTaskListScreen> createState() => _CompletedTaskListScreenState();
}

class _CompletedTaskListScreenState extends State<CompletedTaskListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CompletedTaskListProvider>().getCompletedTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CompletedTaskListProvider>(
        builder: (context, provider, child) {
          if (provider.getCompletedTaskListInProgress) {
            return const CenteredCircularProgress();
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.errorMessage ?? 'Something went wrong'),
                  const Spacer(flex: 1),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CompletedTaskListProvider>().getCompletedTaskList();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.completedTaskList.isEmpty) {
            return const Center(child: Text('No completed tasks available'));
          }

          return ListView.separated(
            itemCount: provider.completedTaskList.length,
            itemBuilder: (context, index) {
              return TaskCard(
                taskModel: provider.completedTaskList[index],
                refreshList: () {
                  context.read<CompletedTaskListProvider>().getCompletedTaskList();
                },
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
