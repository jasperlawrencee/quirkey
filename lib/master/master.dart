// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quirkey/components/constants.dart';
import 'package:quirkey/components/functions.dart';
import 'package:quirkey/components/widgets.dart';
import 'package:quirkey/homepage/home.dart';

class MasterPassword extends StatefulWidget {
  User? currentUser;
  MasterPassword({super.key, required this.currentUser});

  @override
  State<MasterPassword> createState() => _MasterPasswordState();
}

class _MasterPasswordState extends State<MasterPassword> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController mainPasswordController = TextEditingController();
  User? currentUser = auth.currentUser;
  String master = '';

  Future<void> getMasterPassword() async {
    DocumentSnapshot documentSnapshot =
        await db.collection('users').doc(widget.currentUser!.uid).get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    setState(() => master = data['masterPassword']);
    log('grabbed master password');
  }

  Future<void> submitMasterPassword() async {
    checkMasterPassword(
      mainPasswordController.text,
      currentUser!.uid,
    );
    if (await checkMasterPassword(
      mainPasswordController.text,
      currentUser!.uid,
    )) {
      Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => const HomePage(),
          ));
    }
  }

  String? verifyMasterPassword(String? input) {
    if (input != master) {
      return 'Wrong password';
    }
  }

  @override
  void initState() {
    super.initState();
    getMasterPassword();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Container(
        padding: const EdgeInsets.all(defaultPadding),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Vault is locked. Enter Master Password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  )),
              const SizedBox(height: defaultPadding),
              SizedBox(
                width: 200,
                child: Column(
                  children: [
                    Form(
                        key: formKey,
                        child: textField(
                          validator: (p0) =>
                              verifyMasterPassword(mainPasswordController.text),
                          isPassword: true,
                          controller: mainPasswordController,
                          hintText: 'Enter Master Password',
                        )),
                    const SizedBox(height: defaultPadding),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          submitMasterPassword();
                        }
                      },
                      child: const Text(
                        'Unlock',
                        style: TextStyle(color: kPrimaryColor),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
