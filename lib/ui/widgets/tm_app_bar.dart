import 'package:flutter/material.dart';
class TMAppBar extends StatelessWidget implements PreferredSizeWidget   {
  const TMAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AppBar(
      backgroundColor: Colors.green,
      title: Row(
        spacing: 12,
        children: [
          CircleAvatar(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Prosenjit Sarker',
                style: textTheme.bodyLarge?.copyWith(color: Colors.white),
              ),
              Text(
                'prosenjit161@gmail.com',
                style: textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}