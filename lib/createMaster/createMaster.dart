// ignore_for_file: must_be_immutable, file_names

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quirkey/utils/constants.dart';
import 'package:quirkey/utils/widgets.dart';
import 'package:quirkey/masterPassword/master.dart';

class CreateMaster extends StatefulWidget {
  User? currentUser;
  CreateMaster({
    super.key,
    required this.currentUser,
  });

  @override
  State<CreateMaster> createState() => _CreateMasterState();
}

class _CreateMasterState extends State<CreateMaster> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController masterController = TextEditingController();
  final TextEditingController verifyController = TextEditingController();
  bool isSubmitting = false;
  bool isPassword = true;

  @override
  void dispose() {
    masterController.dispose();
    verifyController.dispose();
    super.dispose();
  }

  Future<void> verifyPassword(Function() submit) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        content: const Text(
            "Submit your master password? This action is not changeable"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back')),
          TextButton(onPressed: submit, child: const Text('Submit')),
        ],
      ),
    );
  }

  Future<void> submitMasterPassword() async {
    try {
      setState(() {
        isSubmitting = true;
      });
      db
          .collection('users')
          .doc(widget.currentUser!.uid)
          .update({'masterPassword': masterController.text}).then((value) => {
                setState(() {
                  isSubmitting = false;
                })
              });
    } catch (e) {
      log('error submitting master password $e');
    }
  }

  Future<void> submitForm() async {
    if (formKey.currentState!.validate()) {
      verifyPassword(() => submitMasterPassword().then((value) => {
            Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) =>
                      MasterPassword(currentUser: widget.currentUser),
                ))
          }));
      //push to home
    }
  }

  String? validateMasterPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    } else if (value != masterController.text) {
      return 'Passwords do not match';
    }
    return null;
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
            children: [
              const Text(
                'Master Password',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: defaultPadding),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      MasterPasswordTextField(
                        isHidden: isPassword,
                        controller: masterController,
                        hintText: "Password",
                        validator: (p0) =>
                            validateMasterPassword(masterController.text),
                      ),
                      const SizedBox(height: defaultPadding),
                      MasterPasswordTextField(
                        isHidden: isPassword,
                        controller: verifyController,
                        hintText: "Verify Password",
                        validator: (p0) =>
                            validateConfirmPassword(verifyController.text),
                      )
                    ],
                  )),
              const SizedBox(height: defaultPadding),
              ElevatedButton(
                  onPressed: isSubmitting ? null : submitForm,
                  child: isSubmitting
                      ? const LinearProgressIndicator()
                      : const Text('Submit'))
            ],
          ),
        ),
      ),
    );
  }
}
