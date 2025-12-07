import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';

import '../controllers/auth_controlle.dart';
import '../screens/update_profile_screen.dart';

class TMAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TMAppBar({super.key, this.fromUpdateProfile = false});
  final bool fromUpdateProfile;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AppBar(
      backgroundColor: Colors.green,
      title: GestureDetector(
        onTap: () {
          if (fromUpdateProfile) {
            return;
          }
          Navigator.pushNamed(context, UpdateProfileScreen.name);
        },
        child: Row(
          spacing: 12,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: AuthController.user!.photo.isEmpty
                    ? Icon(Icons.person, size: 24)
                    : Image.memory(
                  base64Decode(AuthController.user!.photo),
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover, // ⭐ MOST IMPORTANT
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AuthController.user?.fullName ?? '',
                  style: textTheme.bodyLarge?.copyWith(color: Colors.white),
                ),
                Text(
                  AuthController.user?.email ?? '',
                  style: textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () async {
            await AuthController.clearUserData();
            Navigator.pushNamedAndRemoveUntil(
              context,
              SignInScreen.name,
              (predicate) => false,
            );
          },
          icon: Icon(Icons.logout,color: Colors.white,),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
