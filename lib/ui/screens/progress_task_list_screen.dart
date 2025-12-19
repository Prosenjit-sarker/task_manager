import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/progress_task_list_provider.dart';
import '../widgets/centered_circular_progress.dart';
import '../widgets/task_card.dart';

class ProgressTaskListScreen extends StatefulWidget {
  const ProgressTaskListScreen({super.key});

  @override
  State<ProgressTaskListScreen> createState() => _ProgressTaskListScreenState();
}

class _ProgressTaskListScreenState extends State<ProgressTaskListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProgressTaskListProvider>().getProgressTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProgressTaskListProvider>(
        builder: (context, provider, child) {
          if (provider.getProgressTaskListInProgress) {
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
                      context.read<ProgressTaskListProvider>().getProgressTaskList();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.progressTaskList.isEmpty) {
            return const Center(child: Text('No progress tasks available'));
          }

          return ListView.separated(
            itemCount: provider.progressTaskList.length,
            itemBuilder: (context, index) {
              return TaskCard(
                taskModel: provider.progressTaskList[index],
                refreshList: () {
                  context.read<ProgressTaskListProvider>().getProgressTaskList();
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
