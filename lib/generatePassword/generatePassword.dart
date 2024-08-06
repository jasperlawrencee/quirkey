// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quirkey/utils/constants.dart';
import 'package:quirkey/utils/functions.dart';
import 'package:quirkey/utils/widgets.dart';

class GeneratePassword extends StatefulWidget {
  User? currentUser;
  GeneratePassword({
    super.key,
    required this.currentUser,
  });

  @override
  State<GeneratePassword> createState() => _GeneratePasswordState();
}

class _GeneratePasswordState extends State<GeneratePassword> {
  bool lowercase = true;
  bool uppercase = true;
  bool numbers = true;
  bool specials = true;
  String specialsCharacters = "!@#\$%^&*()_+-=[]{}|;:<>,.?/";
  String generatedPassword = "";
  int passwordLength = 16;
  final TextEditingController specialController = TextEditingController();
  final TextEditingController characterCountController =
      TextEditingController();

  //returns a string value of each character setting if switches are given true
  String passwordCharacterSet() {
    String charSet = "";
    if (lowercase) charSet += "abcdefghijklmnopqrstuvwxyz";
    if (uppercase) charSet += "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    if (numbers) charSet += "0123456789";
    if (specials) charSet += specialController.text;
    return charSet;
  }

  //validates all switches that should be at least one true
  //BUG
  bool settingChecker() {
    List<bool> booleans = [lowercase, uppercase, numbers, specials];
    return booleans.any((element) => element);
  }

  void generatePassword() {
    if (settingChecker()) {
      String charSet = passwordCharacterSet();
      final Random random = Random();
      String password = '';
      for (int i = 0; i < passwordLength; i++) {
        password += charSet[random.nextInt(charSet.length)];
      }

      setState(() {
        generatedPassword = password;
      });
    } else {
      print('there should be at least one');
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    generatePassword();
    specialController.text = specialsCharacters;
    characterCountController.text = passwordLength.toString();
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
          resizeToAvoidBottomInset: true,
          drawer: SideBar(currentUser: widget.currentUser),
          appBar: AppBar(
            backgroundColor: kPrimaryDarkColor,
            foregroundColor: kBackgroundColor,
            centerTitle: true,
            title: const Text('Generate Password'),
          ),
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(defaultPadding),
              decoration: const BoxDecoration(color: Colors.blueGrey),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: ColoredPassword(password: generatedPassword)),
                      IconButton(
                          onPressed: () => generatePassword(),
                          icon: const FaIcon(
                            FontAwesomeIcons.arrowsRotate,
                            color: kPrimaryDarkColor,
                            size: 16,
                          ))
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        //copy password text method
                        final password = generatedPassword;
                        if (password.isNotEmpty) {
                          await Clipboard.setData(
                              ClipboardData(text: password));
                          print('copied');
                        } else {
                          //show toast failing copy
                        }
                      },
                      child: const Text('COPY')),
                  const SizedBox(height: 64),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text(
                          "Password Length",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: 50,
                          child: TextField(
                            maxLength: 2,
                            style: const TextStyle(color: kBackgroundColor),
                            controller: characterCountController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                if (value.isNotEmpty) {
                                  passwordLength = int.parse(value);
                                } else {
                                  passwordLength = 1;
                                }
                              });
                              generatePassword();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  PasswordSwitchSetting(
                    settingLabel: "Uppercase Letters (A-Z)",
                    swtichValue: uppercase,
                    onSwitchChanged: (p0) {
                      setState(() {
                        uppercase = p0;
                      });
                      generatePassword();
                    },
                  ),
                  PasswordSwitchSetting(
                    settingLabel: "Lowercase Letters (a-z)",
                    swtichValue: lowercase,
                    onSwitchChanged: (p0) {
                      setState(() {
                        lowercase = p0;
                      });
                      generatePassword();
                    },
                  ),
                  PasswordSwitchSetting(
                    settingLabel: "Digits (0-9)",
                    swtichValue: numbers,
                    onSwitchChanged: (p0) {
                      setState(() {
                        numbers = p0;
                      });
                      generatePassword();
                    },
                  ),
                  const SizedBox(height: 32),
                  PasswordSwitchSetting(
                    settingLabel: "Special Characters",
                    swtichValue: specials,
                    onSwitchChanged: (p0) {
                      setState(() {
                        specials = p0;
                      });
                      generatePassword();
                    },
                  ),
                  TextField(
                    style: const TextStyle(color: kBackgroundColor),
                    controller: specialController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[!@#\$%^&*()_+{}|\[\]:;<>,.?/]')),
                      FilteringTextInputFormatter.singleLineFormatter,
                    ],
                    onChanged: (value) {
                      setState(() {
                        specialController.text = value;
                      });
                      generatePassword();
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
