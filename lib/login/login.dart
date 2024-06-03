import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quirkey/components/constants.dart';
import 'package:quirkey/components/widgets.dart';
import 'package:quirkey/features/firebase_services.dart';
import 'package:quirkey/signup/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseServices firebaseServices = FirebaseServices();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Future<void> loginAndRoute() async {
      User? user = await firebaseServices.signInWithEmailAndPassword(
          emailController.text, passwordController.text);
      if (user == null) {
        log('mali xdxd');
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('An error occurred')));
      }
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Container(
        padding: const EdgeInsets.all(defaultPadding),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: defaultPadding),
              textField(
                  isPassword: false,
                  controller: emailController,
                  hintText: 'Email'),
              const SizedBox(height: defaultPadding),
              textField(
                  isPassword: true,
                  controller: passwordController,
                  hintText: 'Password'),
              const SizedBox(height: defaultPadding),
              ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    'Login',
                    style: TextStyle(color: kPrimaryColor),
                  )),
              const SizedBox(height: defaultPadding),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Divider(color: kBackgroundColor, height: 1),
                  Text('or', style: TextStyle(color: kBackgroundColor)),
                  Divider(color: kBackgroundColor),
                ],
              ),
              const SizedBox(height: defaultPadding),
              ElevatedButton(
                  onPressed: () {},
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue with Google',
                        style: TextStyle(color: kPrimaryColor),
                      ),
                    ],
                  )),
              const SizedBox(height: defaultPadding),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupPage(),
                      ));
                },
                child: const Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(
                      color: kBackgroundColor,
                      decoration: TextDecoration.underline,
                      decorationColor: kBackgroundColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
