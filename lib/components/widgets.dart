// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:quirkey/components/constants.dart';

Widget textField({
  String? Function(String?)? validator,
  required bool isPassword,
  required TextEditingController controller,
  required String hintText,
}) {
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
