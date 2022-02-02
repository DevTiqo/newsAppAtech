import 'package:newsapp/theme/theme.dart';

import 'package:flutter/material.dart';

import 'package:flutter_iconly/flutter_iconly.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  const BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    List<List> icons = [
      [
        currentIndex == 0 ? Icon(IconlyBold.home) : Icon(IconlyLight.home),
        "Home"
      ],
      [
        currentIndex == 1
            ? Icon(IconlyBold.bookmark)
            : Icon(IconlyLight.bookmark),
        "Order"
      ],
      [
        currentIndex == 2
            ? Icon(IconlyBold.notification)
            : Icon(IconlyLight.notification),
        "Profile"
      ],
      [
        currentIndex == 3
            ? Icon(IconlyBold.profile)
            : Icon(IconlyLight.profile),
        "Profile"
      ],
    ];

    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      // showSelectedLabels: false,
      // showUnselectedLabels: false,

      onTap: onTap,
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,

      items: icons
          .asMap()
          .map((i, e) => MapEntry(
                i,
                BottomNavigationBarItem(
                  icon: e[0],
                  label: '',
                ),
              ))
          .values
          .toList(),
    );
  }
}
