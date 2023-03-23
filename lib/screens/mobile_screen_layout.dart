import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../utils/colors.dart';
import '../utils/dimens.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
    int _page = 0;
    late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    //Animating Page
    _pageController.jumpToPage(page);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: PageView(
      controller: _pageController,
      onPageChanged: onPageChanged,
      children: homeScreenItems,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home,
                  color: (_page == 0) ? Colors.white : Colors.grey),
              label: '',
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.search,
                  color: (_page == 1) ? Colors.white : Colors.grey),
              label: '',
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle,
                  color: (_page == 2) ? Colors.white : Colors.grey),
              label: '',
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.star,
                  color: (_page == 3) ? Colors.white : Colors.grey),
              label: '',
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.person,
                  color: (_page == 4) ? Colors.black : Colors.grey),
              label: '',
              backgroundColor: Colors.white),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
}
