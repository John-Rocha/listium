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
    apiKey: 'AIzaSyCFCBNAoYGRm9d0XS3JBkrBnE5oPMmg9QA',
    appId: '1:484612447695:web:508059b342918c009986ba',
    messagingSenderId: '484612447695',
    projectId: 'listium-7fd7a',
    authDomain: 'listium-7fd7a.firebaseapp.com',
    storageBucket: 'listium-7fd7a.appspot.com',
    measurementId: 'G-62PWQ5ET18',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBpSly6t-XarPl0G4O09JVK9MIZd72viKs',
    appId: '1:484612447695:android:7f5804093e9004d69986ba',
    messagingSenderId: '484612447695',
    projectId: 'listium-7fd7a',
    storageBucket: 'listium-7fd7a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCMApwcA3gqHWjqdGGCOGgW0PHu6KxPZLA',
    appId: '1:484612447695:ios:f00263daf7c7ede69986ba',
    messagingSenderId: '484612447695',
    projectId: 'listium-7fd7a',
    storageBucket: 'listium-7fd7a.appspot.com',
    iosBundleId: 'com.example.listium',
  );
}