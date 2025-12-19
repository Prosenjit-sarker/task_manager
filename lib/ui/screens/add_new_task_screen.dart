import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/ui/providers/add_new_task_provider.dart';
import 'package:task_manager/ui/providers/new_task_list_provider.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';
import '../widgets/snack_bar_message.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});
  static const String name = '/add-new-task';

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController =
  TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 36),
                  Text('Add New Task',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),

                  /// Title
                  TextFormField(
                    controller: _titleTEController,
                    decoration:
                    const InputDecoration(hintText: 'Title'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Enter your title';
                      }
                      return null;
                    },
                  ),

                  /// Description
                  TextFormField(
                    controller: _descriptionTEController,
                    maxLines: 5,
                    decoration:
                    const InputDecoration(hintText: 'Description'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Enter your description';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 8),

                  /// Button / Loader
                  Consumer<AddNewTaskProvider>(
                    builder: (context, provider, child) {
                      return Visibility(
                        visible: !provider.inProgress,
                        replacement: const Center(
                          child: CircularProgressIndicator(),
                        ),
                        child: FilledButton(
                          onPressed: () =>
                              _onTapSubmitButton(context, provider),
                          child: const Icon(
                              Icons.arrow_circle_right_outlined),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSubmitButton(
      BuildContext context,
      AddNewTaskProvider provider,
      ) async {
    if (_formKey.currentState!.validate()) {
      final isSuccess = await provider.addNewTask(
        title: _titleTEController.text.trim(),
        description: _descriptionTEController.text.trim(),
      );

      if (isSuccess) {
        _clearTextFields();
        context.read<NewTaskListProvider>().getNewTaskList();
        showSnackBarMessage(context, 'New task added');
        Navigator.pop(context, true);
      } else {
        showSnackBarMessage(
          context,
          provider.errorMessage ?? 'Failed to add task',
        );
      }
    }
  }

  void _clearTextFields() {
    _titleTEController.clear();
    _descriptionTEController.clear();
  }

  @override
  void dispose() {
    _titleTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }
}
