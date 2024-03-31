// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA9zDMi1QbIfz5ZXTmFdfeqcdX25YyRaY4',
    appId: '1:359179567065:web:7aebb979b445c2e393a3c8',
    messagingSenderId: '359179567065',
    projectId: 'currencee-df19f',
    authDomain: 'currencee-df19f.firebaseapp.com',
    storageBucket: 'currencee-df19f.appspot.com',
    measurementId: 'G-CJ247HF470',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBeUyjq4lWE7lqKhIVT9Wa-MNgQ9Ox8YEE',
    appId: '1:359179567065:android:d0245073c11391ce93a3c8',
    messagingSenderId: '359179567065',
    projectId: 'currencee-df19f',
    storageBucket: 'currencee-df19f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDG20R8i1CovXNDxBuuhJI1Z7MUtoQSe94',
    appId: '1:359179567065:ios:06fcfdadc39f383c93a3c8',
    messagingSenderId: '359179567065',
    projectId: 'currencee-df19f',
    storageBucket: 'currencee-df19f.appspot.com',
    iosBundleId: 'com.example.currencee',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDG20R8i1CovXNDxBuuhJI1Z7MUtoQSe94',
    appId: '1:359179567065:ios:d4df6880ccfc22b493a3c8',
    messagingSenderId: '359179567065',
    projectId: 'currencee-df19f',
    storageBucket: 'currencee-df19f.appspot.com',
    iosBundleId: 'com.example.currencee.RunnerTests',
  );
}
