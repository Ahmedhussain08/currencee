import 'package:currencee/homeScreen.dart';
import 'package:currencee/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main() async {


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
      theme: ThemeData(
        primaryColor: Color(0xFFFF3F00),
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange.shade700),
        // useMaterial3: true,
      ),
      home: const signup(),
      debugShowCheckedModeBanner: false,
    );
  }
}


