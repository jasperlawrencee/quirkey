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
          )),
    ),
  );
}
