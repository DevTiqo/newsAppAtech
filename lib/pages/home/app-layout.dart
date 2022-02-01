import 'package:newsapp/pages/home/bottom-nav.dart';
import 'package:newsapp/pages/home/home_screen.dart';
import 'package:newsapp/pages/home/order_screen.dart';
import 'package:newsapp/pages/home/profile_screen.dart';
import 'package:newsapp/pages/sign_in.dart';
import 'package:newsapp/theme/theme.dart';
import 'package:riverpod/riverpod.dart';
import 'package:newsapp/notifiers/auth_notifier.dart';
import 'package:flutter/material.dart';

class TabLayout extends StatefulWidget {
  @override
  _TabLayoutState createState() => _TabLayoutState();
}

class _TabLayoutState extends State<TabLayout> {
  int currentIndex = 0;
  late AuthNotifier authNotifier;

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
    Size size = MediaQuery.of(context).size;

    // double horPadding = size.width * 0.06;

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

      // drawer: (Drawer(
      //   child: Text(
      //     'hi',
      //     style: TextStyle(color: Colors.black),
      //   ),
      // )),

      body: IndexedStack(
        index: currentIndex,
        children: [
          const HomeScreen(),
          OrderScreen(
            callback: pageChanged,
          ),
          const ProfileScreen(),
          const ProfileScreen(),
        ],
      ),
    );
  }
}
