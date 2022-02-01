import 'package:newsapp/theme/theme.dart';

import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  const BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    List<List> icons = [
      [
        currentIndex == 0 ? Icon(UniconsLine.home) : Icon(UniconsLine.home),
        "Home"
      ],
      [
        currentIndex == 1
            ? Icon(UniconsSolid.airplay)
            : Icon(UniconsSolid.airplay),
        "Order"
      ],
      [
        currentIndex == 2
            ? Icon(UniconsSolid.airplay)
            : Icon(UniconsSolid.airplay),
        "Profile"
      ],
      [
        currentIndex == 3
            ? Icon(UniconsSolid.airplay)
            : Icon(UniconsSolid.airplay),
        "Profile"
      ],
    ];

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      // showSelectedLabels: false,
      // showUnselectedLabels: false,
      onTap: onTap,
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: primaryColor),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Nunito',
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
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
