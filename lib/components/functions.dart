import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quirkey/components/constants.dart';

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
    return null;
  }
}
