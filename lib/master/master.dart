import 'package:flutter/material.dart';
import 'package:quirkey/components/constants.dart';
import 'package:quirkey/components/widgets.dart';

class MasterPassword extends StatefulWidget {
  const MasterPassword({super.key});

  @override
  State<MasterPassword> createState() => _MasterPasswordState();
}

class _MasterPasswordState extends State<MasterPassword> {
  final TextEditingController mainPasswordController = TextEditingController();

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
              const Text('Vault is locked. Enter your main password',
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
                    textField(
                      isPassword: true,
                      controller: mainPasswordController,
                      hintText: 'Enter main password',
                    ),
                    const SizedBox(height: defaultPadding),
                    ElevatedButton(
                      onPressed: () {},
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
