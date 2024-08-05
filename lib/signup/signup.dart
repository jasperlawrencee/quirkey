import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quirkey/utils/constants.dart';
import 'package:quirkey/features/firebase_services.dart';
import 'package:quirkey/utils/widgets.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey = GlobalKey<FormState>();
  final FirebaseServices firebaseServices = FirebaseServices();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> createUser() async {
    try {
      await firebaseServices
          .signupWithEmailandPassword(
              emailController.text, passwordController.text)
          .then((value) {
        log('created account');
        Navigator.pop(context);
        db.collection('users').doc(value!.uid).set({
          'email': value.email,
          'password': passwordController.text,
          'role': "customer"
        });
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('Password provided too weak');
        throw ('Password too weak');
      } else if (e.code == 'email-already-in-use') {
        log('account with that email already exists');
        throw ('Email already exists');
      }
    }
  }

  String? verifyEmail(String? input) {
    if (input?.isEmpty ?? true) {
      return "Email cannot be empty";
    }
    if (!input!.contains('@')) {
      return 'Invalid email format';
    }
    if (!input.endsWith('.com')) {
      return 'Invalid email domain';
    }
    return null;
  }

  String? verifyPassword(String? input) {
    if (input?.isEmpty ?? true) {
      return 'Password cannot be empty';
    }
    if (input!.length < 6) {
      return 'Password length must be greater than 6';
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
                'Signup',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: defaultPadding),
                      QTextField(
                          validator: (p0) => verifyEmail(emailController.text),
                          controller: emailController,
                          hintText: "Email",
                          isPassword: false),
                      const SizedBox(height: defaultPadding),
                      QTextField(
                          validator: (p0) =>
                              verifyPassword(passwordController.text),
                          controller: passwordController,
                          hintText: "Password",
                          isPassword: true),
                      const SizedBox(height: defaultPadding),
                    ],
                  )),
              ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      createUser();
                    }
                  },
                  child: const Text(
                    'Register Account',
                    style: TextStyle(color: kPrimaryColor),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

//generate password
//alphanumeric
//special characters
//numbers

//verify og gaano ka strong ang password