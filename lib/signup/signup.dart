import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quirkey/components/constants.dart';
import 'package:quirkey/components/widgets.dart';
import 'package:quirkey/features/firebase_services.dart';

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
    } catch (e) {
      log('error signing up $e');
    }
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
                      textField(
                          isPassword: false,
                          controller: emailController,
                          hintText: "Email"),
                      const SizedBox(height: defaultPadding),
                      textField(
                          isPassword: true,
                          controller: passwordController,
                          hintText: "Password"),
                      const SizedBox(height: defaultPadding),
                    ],
                  )),
              ElevatedButton(
                  onPressed: createUser,
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