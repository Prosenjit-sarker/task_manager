import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cancelled_task_list_provider.dart';
import '../widgets/centered_circular_progress.dart';
import '../widgets/task_card.dart';

class CancelledTaskListScreen extends StatefulWidget {
  const CancelledTaskListScreen({super.key});

  @override
  State<CancelledTaskListScreen> createState() => _CancelledTaskListScreenState();
}

class _CancelledTaskListScreenState extends State<CancelledTaskListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CancelledTaskListProvider>().getCancelledTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CancelledTaskListProvider>(
        builder: (context, provider, child) {
          if (provider.getCancelledTaskListInProgress) {
            return const CenteredCircularProgress();
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.errorMessage ?? 'Something went wrong'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CancelledTaskListProvider>().getCancelledTaskList();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.cancelledTaskList.isEmpty) {
            return const Center(child: Text('No cancelled tasks available'));
          }

          return ListView.separated(
            itemCount: provider.cancelledTaskList.length,
            itemBuilder: (context, index) {
              return TaskCard(
                taskModel: provider.cancelledTaskList[index],
                refreshList: () {
                  context.read<CancelledTaskListProvider>().getCancelledTaskList();
                },
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 8);
            },
          );
        },
      ),
    );
  }
}
