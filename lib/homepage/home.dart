// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quirkey/addPassword/addPassword.dart';
import 'package:quirkey/utils/constants.dart';
import 'package:quirkey/utils/functions.dart';
import 'package:quirkey/utils/widgets.dart';
import 'package:quirkey/login/login.dart';

class HomePage extends StatefulWidget {
  User? currentUser;
  HomePage({
    super.key,
    required this.currentUser,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> logoutAndReturnToLogin() async {
    await FirebaseAuth.instance
        .signOut()
        .then((value) => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
            (route) => false));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        showPopDialog(context, logoutAndReturnToLogin);
      },
      child: Scaffold(
          drawer: SideBar(
            currentUser: widget.currentUser,
          ),
          appBar: AppBar(
            backgroundColor: kPrimaryDarkColor,
            foregroundColor: kBackgroundColor,
            centerTitle: true,
            title: const Text('All Entries'),
          ),
          body: Container(
            padding: const EdgeInsets.all(defaultPadding),
            decoration: const BoxDecoration(color: Colors.blueGrey),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
              shape: const CircleBorder(),
              foregroundColor: kPrimaryColor,
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => AddPassword(
                        currentUser: widget.currentUser,
                      ),
                    ));
              },
              child: const Icon(Icons.add))),
    );
  }
}
