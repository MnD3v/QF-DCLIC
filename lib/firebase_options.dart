// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyC899-4UZIa_YO97J1Lhz9_dNbANwahPhg',
    appId: '1:373750335106:web:034a23c2a7c3b13103569b',
    messagingSenderId: '373750335106',
    projectId: 'togo-immobilier-bf507',
    authDomain: 'togo-immobilier-bf507.firebaseapp.com',
    databaseURL: 'https://togo-immobilier-bf507-default-rtdb.firebaseio.com',
    storageBucket: 'togo-immobilier-bf507.appspot.com',
    measurementId: 'G-QQCWLLP7GW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAkyYqAW7e_i_-KGM4QFpfCs6vNpKppnWw',
    appId: '1:373750335106:android:e7c56713af4aec0203569b',
    messagingSenderId: '373750335106',
    projectId: 'togo-immobilier-bf507',
    databaseURL: 'https://togo-immobilier-bf507-default-rtdb.firebaseio.com',
    storageBucket: 'togo-immobilier-bf507.appspot.com',
  );
}
