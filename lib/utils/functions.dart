import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quirkey/utils/constants.dart';

Future<bool> checkMasterPassword(String input, String id) async {
  try {
    DocumentSnapshot documentSnapshot =
        await db.collection('users').doc(id).get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    if (input == data['masterPassword']) {
      log('correct master password');
      return true;
    } else {
      log('wrong master password');
      return false;
    }
  } catch (e) {
    log('error checking master password $e');
    return false;
  }
}

Future<bool?> checkMasterPasswordExists(String id) async {
  try {
    DocumentSnapshot documentSnapshot =
        await db.collection('users').doc(id).get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    if (data.containsKey('masterPassword')) {
      return true; // true is master password is existing
    } else {
      return false; //false if master password is not existing
    }
  } catch (e) {
    log('error getting master password $e');
    await auth.signOut();
    return null;
  }
}

Future<void> showPopDialog(
    BuildContext context, void Function() logoutAndReturnToLogin) async {
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
