import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import '../utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  RxBool isShowUsers = RxBool(false);
  RxString query = RxString('');

  _onSubmit(String text) {
    if(isShowUsers.isFalse) {
      isShowUsers.value = true;
    }
    query.value = text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: Form(
            child: TextFormField(
              decoration:
              const InputDecoration(labelText: 'Search for a user...'),
              onFieldSubmitted: _onSubmit,
            ),
          ),
        ),
        body: Obx(
            () => isShowUsers.isTrue ? _listUsers : _listPosts
        ),
    );
  }

  get _listPosts => StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection('posts')
        .orderBy('datePublished')
        .snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return StaggeredGridView.countBuilder(
        crossAxisCount: 3,
        itemCount: (snapshot.data! as dynamic).docs.length,
        itemBuilder: (context, index) => ClipRRect(
          // borderRadius: BorderRadius.circular(16.0),
          child: Image.network(
              (snapshot.data! as dynamic).docs[index]['postUrl'],
              fit: BoxFit.cover),
        ),
        staggeredTileBuilder: (index) => StaggeredTile.count(
            (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      );
    },
  );

  get _listUsers => FutureBuilder(
    future: FirebaseFirestore.instance
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: query.value)
        .get(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if ((snapshot.data! as dynamic).docs.length == 0) {
        return const Center(
          child: Text('No matching users found'),
        );
      }
      return ListView.builder(
        itemCount: (snapshot.data! as dynamic).docs.length,
        itemBuilder: (context, index) {
          final data = (snapshot.data! as dynamic).docs[index];
          return InkWell(
            onTap: () {},
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(data['photoUrl'],),
                radius: 16,
              ),
              title: Text(data['username'],),
            ),
          );
        },
      );
    },
  );
}
