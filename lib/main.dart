import 'package:coco_seal/firebase_options.dart';
import 'package:coco_seal/auth_gate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.requestPermission();

  runApp(const CocoSealApp());
}

class CocoSealApp extends StatelessWidget {
  const CocoSealApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ココ・シール',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        colorScheme: .fromSeed(seedColor: Colors.pink),
        useMaterial3: true
      ),
      home: const AuthGate(),
      debugShowCheckedModeBanner: false,
    );
  }
}

