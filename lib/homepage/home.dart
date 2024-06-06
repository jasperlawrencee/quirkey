// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quirkey/components/constants.dart';
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
        showPopDialog();
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: kPrimaryDarkColor,
            foregroundColor: kBackgroundColor,
            centerTitle: true,
            title: const Text('All Entries'),
            leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.search))
            ],
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
              onPressed: () {},
              child: const Icon(Icons.add))),
    );
  }

  Future<void> showPopDialog() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Confirm Log Out?',
          style: TextStyle(fontSize: 16),
        ),
        content: const Text('This action will log you out, proceed log out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('BACK'),
          ),
          TextButton(
            onPressed: logoutAndReturnToLogin,
            child: const Text('CONFIRM'),
          ),
        ],
      ),
    );
  }
}
