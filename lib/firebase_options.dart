// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA7ccLDIy1oHJ',
    appId: '1:325590282420:web:',
    messagingSenderId: '325590282420',
    projectId: 'fluttergram-8e839',
    authDomain: 'fluttergram-8e839.firebaseapp.com',
    storageBucket: 'fluttergram-8e839.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD2LU6R51jVDN',
    appId: '1:325590282420:android:',
    messagingSenderId: '325590282420',
    projectId: 'fluttergram-8e839',
    storageBucket: 'fluttergram-8e839.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBcYtgWo0g',
    appId: '1:325590282420:ios:',
    messagingSenderId: '325590282420',
    projectId: 'fluttergram-8e839',
    storageBucket: 'fluttergram-8e839.appspot.com',
    iosClientId: '325590282420-mifei6.apps.googleusercontent.com',
    iosBundleId: 'com.codingapple.instagram',
  );
}
