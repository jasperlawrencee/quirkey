// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quirkey/utils/constants.dart';
import 'package:quirkey/utils/functions.dart';
import 'package:quirkey/utils/models.dart';
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
  // function that grabs all "accounts" fields that contains users passwords
  Future<List<Map<String, dynamic>>> getPasswordsToAnalyze() async {
    try {
      List<Map<String, dynamic>> passwordEntries = [];
      QuerySnapshot passwordDocuments = await db
          .collection('users')
          .doc(widget.currentUser!.uid)
          .collection('entries')
          .where('type', isEqualTo: "account")
          .get();
      passwordDocuments.docs.forEach(
        (element) {
          String title = element['title'];
          String passwordValue = element['value']['password'];
          String strength = analyzePassword(passwordValue);
          passwordEntries.add({
            'title': title,
            'password': passwordValue,
            'strength': strength,
          });
        },
      );
      return passwordEntries;
    } catch (e) {
      print("Error getting passwords to verify $e");
      return [];
    }
  }

  // analyzing password strength based on uniqueness
  String analyzePassword(String password) {
    int strengthLevel = 0;

    // check password length
    if (password.length >= 8) {
      strengthLevel++;
    }

    // check for uniqueness
    bool hasLowercase = RegExp(r'[a-z]').hasMatch(password);
    bool hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
    bool hasNumber = RegExp(r'\d').hasMatch(password);
    bool hasSpecialChar =
        RegExp(r'/^[ A-Za-z0-9_@./#&+-]*$/.').hasMatch(password);

    if (hasLowercase) strengthLevel++;
    if (hasUppercase) strengthLevel++;
    if (hasNumber) strengthLevel++;
    if (hasSpecialChar) strengthLevel++;

    PasswordStrength strength;
    switch (strengthLevel) {
      case 1:
        strength = PasswordStrength.weak;
        break;
      case 2:
        strength = PasswordStrength.medium;
        break;
      case 3:
        strength = PasswordStrength.medium;
        break;
      case 4:
        strength = PasswordStrength.strong;
        break;
      default:
        strength = PasswordStrength.veryStrong;
    }
    return strength.toString();
  }

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
            child: FutureBuilder(
                future: getPasswordsToAnalyze(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    List<Map<String, dynamic>> analyzedPasswords =
                        snapshot.data!;

                    // Group passwords by strength
                    Map<String, List<Map<String, dynamic>>>
                        passwordsByStrength = {};
                    for (var password in analyzedPasswords) {
                      passwordsByStrength
                          .putIfAbsent(password['strength'], () => [])
                          .add(password);
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${snapshot.data!.length} Passwords",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: passwordsByStrength.keys.length,
                          itemBuilder: (context, index) {
                            String strength =
                                passwordsByStrength.keys.elementAt(index);
                            List<Map<String, dynamic>> passwords =
                                passwordsByStrength[strength]!;
                            return CheckerButton(
                              icon: const Icon(Icons.lock),
                              title: "${passwords.length} Passwords",
                              detail: strength,
                            );
                          },
                        )
                      ],
                    );
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No passwords'),
                    );
                  } else {
                    return const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: kPrimaryColor),
                          SizedBox(height: defaultPadding / 2),
                          Text('Loading Passwords')
                        ],
                      ),
                    );
                  }
                }),
          ),
        ));
  }

  InkWell CheckerButton({
    required Icon icon,
    required String title,
    required String detail,
  }) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(defaultPadding / 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                const SizedBox(width: defaultPadding),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(detail),
                  ],
                )
              ],
            ),
            const Icon(Icons.keyboard_arrow_right_rounded)
          ],
        ),
      ),
    );
  }
}
