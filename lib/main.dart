import 'dart:html';

import 'package:currencee/homeScreen.dart';
import 'package:currencee/login.dart';
import 'package:currencee/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
   // checkuser(){
   //   final user = FirebaseAuth.instance.currentUser;
   //   if(user!= null){
   //     return homeScreen();
   //   }
   //   else{
   //     return login();
   //   }
   //
   // }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xFFFF3F00),
        scaffoldBackgroundColor: Color(0xFEFEFE),
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 23,fontWeight:FontWeight.w800,color: Color(0xFFFF3F00))
        )
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange.shade700),
        // useMaterial3: true,
      ),
      home: homeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}


