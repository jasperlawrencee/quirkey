//colors
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final db = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;

const kPrimaryColor = Color.fromARGB(255, 0, 41, 128);
const kPrimaryDarkColor = Color.fromARGB(255, 0, 14, 44);
const kSecondaryColor = Color.fromARGB(255, 170, 204, 255);
const kBackgroundColor = Color.fromARGB(255, 242, 242, 242);

const defaultPadding = 16.0;
