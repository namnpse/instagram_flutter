import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class MobileScreenLayout extends StatelessWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () => FirebaseAuth.instance.signOut(),
          child: Text(
            userProvider.getUser.username,
          ),
        ),
      ),
    );
  }
}
