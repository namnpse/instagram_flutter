import 'package:flutter/cupertino.dart';

import '../screens/add_post_screen.dart';
import '../screens/feed_screen.dart';

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
  const Text('SearchScreen'),
  const AddPostScreen(),
  const Text('Notifications'),
  const Text('ProfileScreen'),
];