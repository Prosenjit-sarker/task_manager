import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../../ui/controllers/auth_controlle.dart';
import '../models/user_model.dart';
import '../service/network_caller.dart';
import '../utils/urls.dart';

class UpdateProfileProvider extends ChangeNotifier {
  bool _updateProfileInProgress = false;
  String? _errorMessage;
  XFile? _pickedImage;

  final TextEditingController emailTEController = TextEditingController();
  final TextEditingController firstNameTEController = TextEditingController();
  final TextEditingController lastNameTEController = TextEditingController();
  final TextEditingController mobileTEController = TextEditingController();
  final TextEditingController passwordTEController = TextEditingController();

  final ImagePicker imagePicker = ImagePicker();

  bool get updateProfileInProgress => _updateProfileInProgress;
  String? get errorMessage => _errorMessage;
  XFile? get pickedImage => _pickedImage;

  UpdateProfileProvider() {
    _initializeUserData();
  }

  void _initializeUserData() {
    final UserModel userModel = AuthController.user!;
    emailTEController.text = userModel.email;
    firstNameTEController.text = userModel.firstName;
    lastNameTEController.text = userModel.lastName;
    mobileTEController.text = userModel.mobile;
  }

  Future<void> pickImage() async {
    XFile? image = await imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      _pickedImage = image;
      notifyListeners();
    }
  }

  Future<bool> updateProfile() async {
    bool isSuccess = false;
    _updateProfileInProgress = true;
    _errorMessage = null;
    notifyListeners();

    Map<String, dynamic> requestBody = {
      'email': emailTEController.text,
      'firstName': firstNameTEController.text.trim(),
      'lastName': lastNameTEController.text.trim(),
      'mobile': mobileTEController.text.trim(),
    };

    if (passwordTEController.text.isNotEmpty) {
      requestBody['password'] = passwordTEController.text;
    }

    if (_pickedImage != null) {
      Uint8List imageByte = await _pickedImage!.readAsBytes();
      requestBody['photo'] = base64Encode(imageByte);
    }

    final NetworkResponse response = await NetworkCaller.postRequest(Urls.updateProfileUrl, body: requestBody);

    if (response.isSuccess) {
      requestBody['_id'] = AuthController.user!.id;
      await AuthController.updateUserData(UserModel.formJson(requestBody));
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }

    _updateProfileInProgress = false;
    notifyListeners();

    return isSuccess;
  }

  @override
  void dispose() {
    emailTEController.dispose();
    firstNameTEController.dispose();
    lastNameTEController.dispose();
    mobileTEController.dispose();
    passwordTEController.dispose();
    super.dispose();
  }
}
