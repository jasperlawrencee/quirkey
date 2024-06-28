// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quirkey/utils/constants.dart';
import 'package:quirkey/utils/functions.dart';
import 'package:quirkey/login/login.dart';

//application's text field design
class QTextField extends StatelessWidget {
  String? Function(String?)? validator;
  bool isPassword;
  List<TextInputFormatter>? inputList;
  TextInputType? textInputType;
  TextEditingController controller;
  String hintText;
  int? maxLines;

  QTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.isPassword,
    this.validator,
    this.inputList,
    this.textInputType,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: kSecondaryColor,
            blurRadius: 6.0,
            spreadRadius: 0.0,
            offset: Offset(
              1.0,
              1.0,
            ),
          ),
        ],
      ),
      child: TextFormField(
        maxLines: isPassword
            ? 1
            : maxLines, //flutter errors when obscured text has maxlines greater than 1
        keyboardType: textInputType,
        inputFormatters: inputList,
        validator: validator,
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

//application's dropdown design
class QStringDropDown extends StatefulWidget {
  Function(String?) onchanged;
  List<String> list;
  String value;
  QStringDropDown({
    super.key,
    required this.list,
    required this.value,
    required this.onchanged,
  });

  @override
  State<QStringDropDown> createState() => _QStringDropDownState();
}

class _QStringDropDownState extends State<QStringDropDown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
      decoration: BoxDecoration(
        color: kPrimaryDarkColor,
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: kSecondaryColor,
            blurRadius: 6.0,
            spreadRadius: 0.0,
            offset: Offset(
              1.0,
              1.0,
            ),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(canvasColor: kPrimaryDarkColor),
        child: DropdownButton(
          isExpanded: true,
          underline: Container(
            height: 0,
            color: kBackgroundColor,
          ),
          icon: const Icon(
            Icons.arrow_drop_down,
            color: kBackgroundColor,
          ),
          value: widget.value,
          items: widget.list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(color: kBackgroundColor, fontSize: 14),
                ));
          }).toList(),
          onChanged: widget.onchanged,
        ),
      ),
    );
  }
}

//application's textfield with show password icon
class MasterPasswordTextField extends StatefulWidget {
  bool isHidden;
  TextEditingController controller;
  String hintText;
  String? Function(String?) validator;

  MasterPasswordTextField({
    super.key,
    required this.isHidden,
    required this.controller,
    required this.hintText,
    required this.validator,
  });

  @override
  State<MasterPasswordTextField> createState() =>
      _MasterPasswordTextFieldState();
}

class _MasterPasswordTextFieldState extends State<MasterPasswordTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: kSecondaryColor,
            blurRadius: 6.0,
            spreadRadius: 0.0,
            offset: Offset(
              1.0,
              1.0,
            ),
          ),
        ],
      ),
      child: TextFormField(
        validator: widget.validator,
        controller: widget.controller,
        obscureText: widget.isHidden ? true : false,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
            suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    widget.isHidden = !widget.isHidden;
                  });
                },
                icon: const Icon(Icons.remove_red_eye_outlined))),
      ),
    );
  }
}

//application's sidebar in homepage
class SideBar extends StatelessWidget {
  User? currentUser;
  SideBar({
    super.key,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: kPrimaryDarkColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            //header widget containing preview of users email
            accountName: const Text(
              "Quirkey",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: kBackgroundColor),
            ),
            accountEmail: Text(currentUser!.email!),
            decoration: const BoxDecoration(
                color:
                    kPrimaryColor, //replaces cover with solid color if network image doesnt load
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        "https://img.freepik.com/premium-photo/abstract-background-images-wallpaper-ai-generated_643360-18507.jpg"))),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  // placeholder pingpong dingdong
                  // replace with firestore field containing imageurl of user
                  'https://aphrodite.gmanetwork.com/entertainment/photos/photo/in_photos__the_best_dingdong_dantes_memes_pingpong_dantes__1578366896.jpg',
                  width: 75,
                  height: 75,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.lock_outline,
              color: kBackgroundColor,
            ),
            title: const Text(
              'Passwords',
              style: TextStyle(color: kBackgroundColor),
            ),
            onTap: () {
              log('password');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.settings_outlined,
              color: kBackgroundColor,
            ),
            title: const Text(
              'Settings',
              style: TextStyle(color: kBackgroundColor),
            ),
            onTap: () {
              log('settings');
            },
          ),
          const Divider(color: kBackgroundColor),
          ListTile(
            leading: const Icon(
              Icons.abc_outlined,
              color: kBackgroundColor,
            ),
            title: const Text(
              'Generate Password',
              style: TextStyle(color: kBackgroundColor),
            ),
            onTap: () {
              log('generate password');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.fact_check_outlined,
              color: kBackgroundColor,
            ),
            title: const Text(
              'Check Password',
              style: TextStyle(color: kBackgroundColor),
            ),
            onTap: () {
              log('Check Password');
            },
          ),
          const Divider(color: kBackgroundColor),
          ListTile(
            leading: const Icon(
              Icons.logout_outlined,
              color: kBackgroundColor,
            ),
            title: const Text(
              'Logout',
              style: TextStyle(color: kBackgroundColor),
            ),
            onTap: () async {
              showPopDialog(context, () async {
                await FirebaseAuth.instance
                    .signOut()
                    .then((value) => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                        (route) => false));
              });
            },
          ),
        ],
      ),
    );
  }
}
