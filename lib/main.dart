import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quirkey/utils/constants.dart';
import 'package:quirkey/utils/functions.dart';
import 'package:quirkey/createMaster/createMaster.dart';
import 'package:quirkey/firebase_options.dart';
import 'package:quirkey/login/login.dart';
import 'package:quirkey/masterPassword/master.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
        useMaterial3: true,
        dialogTheme: const DialogTheme(
          shape: Border(),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: kBackgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          maximumSize: const Size(double.infinity, 40),
          minimumSize: const Size(double.infinity, 40),
        )),
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          iconColor: kPrimaryColor,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: defaultPadding / 2, vertical: defaultPadding / 2),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide.none),
          filled: true,
          fillColor: kPrimaryDarkColor,
        ),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, currentUser) {
          if (currentUser.data == null) {
            return const LoginPage(); // if user is not logged in
          } else {
            return FutureBuilder(
              future: checkMasterPasswordExists(currentUser.data!.uid),
              builder: (context, masterExists) {
                if (masterExists.hasData) {
                  if (masterExists.data! == true) {
                    // logged in and has master
                    return MasterPassword(currentUser: currentUser.data!);
                  } else {
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
                    // logged in but no master password
                    return CreateMaster(currentUser: currentUser.data!);
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ); // if user is logged in
          }
        },
      ),
    );
  }
}
