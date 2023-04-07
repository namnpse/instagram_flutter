import 'package:flutter/cupertino.dart';

import '../screens/add_post_screen.dart';
import '../screens/feed_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/search_screen.dart';

const webScreenSize = 600;

// List<Widget> homeScreenItems = [
//   const FeedScreen(),
//   const SearchScreen(),
//   const AddPostScreen(),
//   const Text('notifications'),
//   ProfileScreen(
//     uid: FirebaseAuth.instance.currentUser!.uid,
//   ),
// ];

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text('Notifications'),
  ProfileScreen(),
];

extension StringExtension on String {
  String removeAllWhitespace() {
    return replaceAll(RegExp(r"\s+"), "");
  }

  bool validPhone() {
    return RegExp(r'(^(0\d{9})$)').hasMatch(this);
  }

  bool validEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}