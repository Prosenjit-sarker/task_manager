import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/data/providers/update_profile_provider.dart';
import '../widgets/photo_picker.dart';
import '../widgets/tm_app_bar.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  static const String name = '/update-profile';

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(fromUpdateProfile: true),
      body: ScreenBackground(
        child: Consumer<UpdateProfileProvider>(
          builder: (context, provider, child) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      // ignore: sized_box_for_spacer
                      SizedBox(height: 20),
                      Text('Update Profiles', style: Theme.of(context).textTheme.titleLarge),
                      GestureDetector(
                        onTap: () {
                          provider.pickImage();
                        },
                        child: PhotoPicker(pickedImage: provider.pickedImage),
                      ),
                      TextFormField(
                        enabled: false,
                        controller: provider.emailTEController,
                        decoration: const InputDecoration(hintText: 'Email'),
                      ),
                      TextFormField(
                        controller: provider.firstNameTEController,
                        decoration: const InputDecoration(hintText: 'First name'),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter first name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: provider.lastNameTEController,
                        decoration: const InputDecoration(hintText: 'Last name'),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter last name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: provider.mobileTEController,
                        decoration: const InputDecoration(hintText: 'Mobile'),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter mobile number';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: provider.passwordTEController,
                        decoration: const InputDecoration(hintText: 'Password'),
                        validator: (String? value) {
                          String password = value ?? '';
                          if (password.isNotEmpty && password.length < 6) {
                            return 'Enter a password at least 6 letters';
                          }
                          return null;
                        },
                      ),
                      Visibility(
                        visible: !provider.updateProfileInProgress,
                        replacement: const Center(child: CircularProgressIndicator()),
                        child: SizedBox(
                          // ignore: avoid_unnecessary_containers
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                provider.updateProfile().then((isSuccess) {
                                  if (mounted) {
                                    if (isSuccess) {
                                      showSnackBarMessage(context, 'Profile updated successfully');
                                    } else {
                                      showSnackBarMessage(context, provider.errorMessage ?? 'Update failed');
                                    }
                                  }
                                });
                              }
                            },
                            child: const Text('Update'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
