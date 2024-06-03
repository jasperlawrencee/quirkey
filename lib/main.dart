import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quirkey/components/constants.dart';
import 'package:quirkey/firebase_options.dart';
import 'package:quirkey/homepage/home.dart';
import 'package:quirkey/login/login.dart';

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
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            //user is not logged in
            return const LoginPage();
          } else {
            return const HomePage(); //
          }
        },
      ),
    );
  }
}
