import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/providers/task_card_provider.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.taskModel, required this.refreshList});
  final TaskCountModel taskModel;
  final VoidCallback refreshList;

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskCardProvider>(
      builder: (context, provider, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: ListTile(
            tileColor: Colors.white,
            title: Text(taskModel.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(taskModel.description, style: const TextStyle(color: Colors.grey)),
                Text('Date: ${taskModel.createdDate}'),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(taskModel.status),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        taskModel.status,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Spacer(),
                    Visibility(
                      visible: !provider.deleteTaskInProgress,
                      replacement: const Center(child: CircularProgressIndicator()),
                      child: IconButton(
                        onPressed: () {
                          provider.deleteTask(taskModel.id).then((isSuccess) {
                            if (isSuccess) {
                              refreshList();
                            } else {
                              showSnackBarMessage(context, 'Delete failed');
                            }
                          });
                        },
                        icon: const Icon(Icons.delete, color: Colors.grey),
                      ),
                    ),
                    Visibility(
                      visible: !provider.changeStatusInProgress,
                      replacement: const Center(child: CircularProgressIndicator()),
                      child: IconButton(
                        onPressed: () {
                          _showChangeStatusDialog(context, provider);
                        },
                        icon: const Icon(Icons.edit, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showChangeStatusDialog(BuildContext context, TaskCardProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Change Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('New'),
                trailing: _isCurrentStatus('New') ? const Icon(Icons.done) : null,
                onTap: () {
                  _onTapChangeTaskTile(context, provider, 'New');
                },
              ),
              ListTile(
                title: const Text('Progress'),
                trailing: _isCurrentStatus('Progress') ? const Icon(Icons.done) : null,
                onTap: () {
                  _onTapChangeTaskTile(context, provider, 'Progress');
                },
              ),
              ListTile(
                title: const Text('Cancelled'),
                trailing: _isCurrentStatus('Cancelled') ? const Icon(Icons.done) : null,
                onTap: () {
                  _onTapChangeTaskTile(context, provider, 'Cancelled');
                },
              ),
              ListTile(
                title: const Text('Completed'),
                trailing: _isCurrentStatus('Completed') ? const Icon(Icons.done) : null,
                onTap: () {
                  _onTapChangeTaskTile(context, provider, 'Completed');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _onTapChangeTaskTile(BuildContext context, TaskCardProvider provider, String status) {
    if (_isCurrentStatus(status)) return;
    Navigator.pop(context);
    provider.changeStatus(taskModel.id, status).then((isSuccess) {
      if (isSuccess) {
        refreshList();
      } else {
        showSnackBarMessage(context, 'Status change failed');
      }
    });
  }

  bool _isCurrentStatus(String status) {
    return taskModel.status == status;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'New':
        return Colors.blue;
      case 'Progress':
        return Colors.amber;
      case 'Cancelled':
        return Colors.red;
      case 'Completed':
        return Colors.green;
      default:
        return Colors.pink;
    }
  }
}
