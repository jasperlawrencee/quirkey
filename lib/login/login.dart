// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quirkey/utils/constants.dart';
import 'package:quirkey/utils/functions.dart';
import 'package:quirkey/utils/widgets.dart';
import 'package:quirkey/createMaster/createMaster.dart';
import 'package:quirkey/features/firebase_services.dart';
import 'package:quirkey/masterPassword/master.dart';
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
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Future<void> loginAndRoute() async {
      setState(() {
        isLoading = true;
      });
      User? user = await firebaseServices.signInWithEmailAndPassword(
          emailController.text, passwordController.text);
      if (user == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('An error occurred')));
        setState(() {
          isLoading = false;
        });
      } else {
        if (await checkMasterPasswordExists(user.uid) != null &&
            await checkMasterPasswordExists(user.uid) == true) {
          try {
            Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => MasterPassword(
                      currentUser: user), // if master password is existing
                ));
          } catch (e) {
            log(e.toString());
          }
        } else {
          Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => CreateMaster(
                    currentUser: user), // placeholder widget to be made unya na
              ));
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text(
                        'Setting Your Master Password',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: const Text(
                          'Create a strong and unique password. This password protects all your other passwords inside this vault, so make it hard to guess and do not forget it by all means!'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Close'))
                      ],
                    ));
          });
        }
        setState(() {
          isLoading = false;
        });
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
              QTextField(
                  controller: emailController,
                  hintText: "Email",
                  isPassword: false),
              const SizedBox(height: defaultPadding),
              QTextField(
                  controller: passwordController,
                  hintText: "Password",
                  isPassword: true),
              const SizedBox(height: defaultPadding),
              ElevatedButton(
                  onPressed: isLoading ? null : loginAndRoute,
                  child: isLoading
                      ? const LinearProgressIndicator(color: kPrimaryColor)
                      : const Text(
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
                  // onPressed: () => GoogleAuth().signInWithGoogle(), google error
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.google,
                        size: 16,
                      ),
                      SizedBox(width: defaultPadding / 2),
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
