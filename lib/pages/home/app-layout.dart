import 'package:newsapp/pages/home/bottom-nav.dart';
import 'package:newsapp/pages/home/home_screen.dart';
import 'package:newsapp/pages/home/notification_screen.dart';
import 'package:newsapp/pages/home/saved_screen.dart';
import 'package:newsapp/pages/home/profile_screen.dart';
import 'package:newsapp/notifiers/auth_notifier.dart';
import 'package:flutter/material.dart';

class TabLayout extends StatefulWidget {
  @override
  _TabLayoutState createState() => _TabLayoutState();
}

class _TabLayoutState extends State<TabLayout> {
  int currentIndex = 0;

  final PageController pageController = PageController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  pageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNav(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      body: IndexedStack(
        index: currentIndex,
        children: [
          HomeScreen(),
          SavedScreen(
            callback: pageChanged,
          ),
          NotificationScreen(),
          ProfileScreen(),
        ],
      ),
    );
  }
}
