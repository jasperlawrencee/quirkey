// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quirkey/utils/constants.dart';
import 'package:quirkey/utils/functions.dart';
import 'package:quirkey/utils/widgets.dart';

class CheckPassword extends StatefulWidget {
  User? currentUser;
  CheckPassword({
    super.key,
    required this.currentUser,
  });

  @override
  State<CheckPassword> createState() => _CheckPasswordState();
}

class _CheckPasswordState extends State<CheckPassword> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) {
            return;
          }
          showPopDialog(context, () {
            logoutAndReturnToLogin(context);
          });
        },
        child: Scaffold(
          drawer: SideBar(currentUser: widget.currentUser),
          appBar: AppBar(
            backgroundColor: kPrimaryDarkColor,
            foregroundColor: kBackgroundColor,
            centerTitle: true,
            title: const Text('Check Password'),
          ),
          body: Container(
            padding: const EdgeInsets.all(defaultPadding),
            decoration: const BoxDecoration(color: Colors.blueGrey),
            child: const Center(),
          ),
        ));
  }
}
