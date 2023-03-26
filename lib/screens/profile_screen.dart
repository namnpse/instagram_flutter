import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user.dart' as app;
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../resource/firestore_methods.dart';
import '../utils/colors.dart';
import '../widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  String? uid;
  ProfileScreen({Key? key, this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isFollowing = false;
  int postsLen = 0;
  var userData = {};
  bool isLoading = false;
  int followers = 0;
  String? userId;

  @override
  void initState() {
    if(widget.uid != null && widget.uid!.isEmpty) {
      userId = widget.uid;
    } else {
      // userId = Provider.of<UserProvider>(context).getUser.uid;
      userId = FirebaseAuth.instance.currentUser!.uid;
    }
    super.initState();
    getPostsLen();
  }

  getPostsLen() async {
    setState(() {
      isLoading = true;
    });
    var postSnap = await FirebaseFirestore.instance
        .collection("posts")
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    postsLen = postSnap.docs.length;
    var userSnap = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .get();
    userData = userSnap.data()!;
    isFollowing = userSnap['followers']?.contains(FirebaseAuth.instance.currentUser!.uid) ?? false;
    followers = userSnap['followers']?.length ?? 0;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final app.User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(
          user.username,
        ),
        centerTitle: false,
      ),
      body: ListView(
        children: <Widget>[
          // Profile Picture, Stats column, Follow, Unfollow Button, username and bio
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40.0,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
                    // stats
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              buildStatColumn("posts", postsLen),
                              buildStatColumn("followers", followers),
                              buildStatColumn("following", userData['following']?.length ?? 0),
                            ],
                          ),
                          // buttons -> edit profile, follow, unfollow
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                user.uid == userId
                                    ? FollowButton(
                                  text: "Edit Profile",
                                  backgroundColor: mobileBackgroundColor,
                                  textColor: primaryColor,
                                  borderColor: Colors.grey,
                                  function: () {},
                                )
                                    : isFollowing
                                    ? FollowButton(
                                  text: "Unfollow",
                                  backgroundColor: Colors.white,
                                  textColor: Colors.black,
                                  borderColor: Colors.grey,
                                  function: () async {
                                    await FireStoreMethods().followUser(user.uid, userData['uid']);
                                    setState(() {
                                      isFollowing = false;
                                      followers--;
                                    });
                                  },
                                )
                                    : FollowButton(
                                  text: "Follow",
                                  backgroundColor: Colors.blue,
                                  textColor: Colors.white,
                                  borderColor: Colors.blue,
                                  function: () async {
                                    await FireStoreMethods()
                                        .followUser(
                                      user.uid,
                                      userData['uid'],
                                    );
                                    setState(() {
                                      isFollowing = true;
                                      followers++;
                                    });
                                  },
                                ),
                              ]),
                        ],
                      ),
                    )
                  ],
                ),
                // usernmae and description
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Text(
                      user.username,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 1.0),
                  child: Text(user.bio),
                ),
              ],
            ),
          ),
          const Divider(),
          // displaying user posts
          FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('posts')
                .where('uid', isEqualTo: user.uid)
                .get(),
            builder: (BuildContext coontext, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: (snapshot.data! as dynamic).docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: 1.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot video =
                  (snapshot.data! as dynamic).docs[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      (video.data()! as dynamic)["postUrl"],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                      errorBuilder: (context, exception, stackTrace) {
                        return const SizedBox(
                          height: 200,
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Column buildStatColumn(String label, int number) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          number.toString(),
          style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        Container(
            margin: const EdgeInsets.only(top: 4.0),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
              ),
            ))
      ],
    );
  }

  int _countFollowings(Map followings) {
    int count = 0;

    void countValues(key, value) {
      if (value) {
        count += 1;
      }
    }

    followings.forEach(countValues);

    return count;
  }
}
