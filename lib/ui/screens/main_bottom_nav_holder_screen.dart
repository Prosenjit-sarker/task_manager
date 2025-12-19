import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/ui/providers/bottom_nav_provider.dart';
import 'package:task_manager/ui/screens/cancelled_task_list_screen.dart';
import 'package:task_manager/ui/screens/completed_task_screen.dart';
import 'package:task_manager/ui/screens/new_task_list_screen.dart';
import 'package:task_manager/ui/screens/progress_task_list_screen.dart';
import '../widgets/tm_app_bar.dart';

class MainBottomNavHolderScreen extends StatelessWidget {
  const MainBottomNavHolderScreen({super.key});
  static const String name = '/main-bottom-nav-holder';

  static final List<Widget> _screens = [
    NewTaskListScreen(),
    ProgressTaskListScreen(),
    CancelledTaskListScreen(),
    CompletedTaskListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: TMAppBar(),
          body: _screens[provider.selectedIndex],
          bottomNavigationBar: NavigationBar(
            selectedIndex: provider.selectedIndex,
            onDestinationSelected: provider.changeIndex,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.new_label_outlined),
                label: 'New',
              ),
              NavigationDestination(
                icon: Icon(Icons.access_time),
                label: 'Progress',
              ),
              NavigationDestination(
                icon: Icon(Icons.cancel_outlined),
                label: 'Cancelled',
              ),
              NavigationDestination(
                icon: Icon(Icons.done),
                label: 'Completed',
              ),
            ],
          ),
        );
      },
    );
  }
}
