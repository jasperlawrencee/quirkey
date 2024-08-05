import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quirkey/login/login.dart';
import 'package:quirkey/utils/constants.dart';

Future<bool> checkMasterPassword(String input, String id) async {
  try {
    DocumentSnapshot documentSnapshot =
        await db.collection('users').doc(id).get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    if (input == data['masterPassword']) {
      return true; //correct password
    } else {
      return false; //wrong password
    }
  } catch (e) {
    return false; //error checking password
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
    //default error
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

Future<String> generatePassword() async {
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random rand = Random();
  //random generated password
  String password = String.fromCharCodes(Iterable.generate(
    16, //sets maximum character count to value
    (index) => chars.codeUnitAt(rand.nextInt(chars.length)),
    //gives a random element of the string "chars" declared above and iterates it resulting a string
  ));
  return password;
}

Future<void> addNotesEntry({
  required String notes,
  required String title,
}) async {
  try {
    await db
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('entries')
        .add({
      "title": title,
      "type": "notes",
      "value": {"notes": notes},
    }).then((value) => print('done'));
  } catch (e) {
    print('error adding notes');
  }
}

Future<void> addAccountEntry({
  required String login,
  required String password,
  required String title,
  required String details,
}) async {
  try {
    await db
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('entries')
        .add({
      "value": {
        "details": details,
        "login": login,
        "password": password,
      },
      "title": title,
      "type": "account",
    }).then((value) => print('done'));
  } catch (e) {
    print('error adding account');
  }
}

Future<void> addAddress({
  required String region,
  required String state,
  required String city,
  required String postal,
  required String street,
  required String title,
  String? firstname,
  String? lastname,
  String? middlename,
}) async {
  try {
    await db
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('entries')
        .add({
      "value": {
        "region": region,
        "state": state,
        "city": city,
        "postalCode": postal,
        "street": street,
        "firstName": firstname ?? '',
        "lastName": lastname ?? '',
        "middleName": middlename ?? '',
      },
      "title": title,
      "type": "address",
    }).then((value) => print('done'));
  } catch (e) {
    print('error adding address');
  }
}

Future<void> addBank({
  required String cardNumber,
  required String month,
  required String year,
  required String security,
  required String title,
  String? pin,
  String? cardIssuer,
  String? supportNumber,
  String? comment,
}) async {
  try {
    await db
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('entries')
        .add({
      "title": title,
      "type": "bank",
      "value": {
        "cardNumber": cardNumber,
        "month": month,
        "year": year,
        "security": security,
        "pin": pin ?? '',
        "cardIssuer": cardIssuer ?? '',
        "supportNumber": supportNumber ?? '',
        "comment": comment ?? '',
      },
    }).then((value) => print('done'));
  } catch (e) {
    print('error adding bank');
  }
}

Future<QuerySnapshot?> getSortedEntries(String type, String documentId) async {
  try {
    if (type.toLowerCase() == 'all') {
      return await db
          .collection('users')
          .doc(documentId)
          .collection('entries')
          .get();
    } else if (type == type) {
      return await db
          .collection('users')
          .doc(documentId)
          .collection('entries')
          .where('type', isEqualTo: type.toLowerCase())
          .get();
    }
    return null;
  } catch (e) {
    print('error getting entires $e');
    return null;
  }
}

Future<void> showToast(String text) async {
  await Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: kPrimaryDarkColor,
    textColor: kBackgroundColor,
    fontSize: 16,
  );
}

String? toUppercaseFirstCharacter(String input) {
  if (input.isEmpty) return null;
  var firstChar = input[0].toUpperCase(); //uppercases the first letter only
  var remainingChars =
      input.substring(1); //gets the remaining strings of the input
  return firstChar + remainingChars;
}

Future<void> logoutAndReturnToLogin(BuildContext context) async {
  await FirebaseAuth.instance
      .signOut()
      .then((value) => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
          (route) => false));
}

class GoogleAuth {
  signInWithGoogle() async {
    //init google signup
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    //auth details from request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    //user credential
    final credentials = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credentials);
  }
}
