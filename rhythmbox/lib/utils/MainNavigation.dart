import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:rhythmbox/screens/HomePage.dart';
import 'package:rhythmbox/screens/MyPlayList.dart';
import 'package:rhythmbox/screens/PlayList.dart';
import 'package:rhythmbox/screens/profile.dart';
import 'package:rhythmbox/utils/constants.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomePage(),
    Playlist(),
    MyPlayList(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      backgroundColor: appBackground,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: GNav(
              gap: 8,
              backgroundColor: Colors.transparent,
              color: Colors.grey,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.grey.shade800,
              tabBorderRadius: 20,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              tabMargin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.library_music,
                  text: 'Playlist',
                ),
                GButton(
                  icon: Icons.queue_music,
                  text: 'My List',
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
