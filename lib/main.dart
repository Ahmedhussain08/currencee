
import 'package:currencee/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        useMaterial3: true,
        primaryColor: Colors.deepOrange,

        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 23,fontWeight:FontWeight.w900,)
        )
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange.shade700),
      ),
      home: splash_screen(),
      debugShowCheckedModeBanner: false,
    );
  }
}


