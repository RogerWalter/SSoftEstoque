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
    apiKey: 'AIzaSyAY6dzyMV1NfmFvyhCnSiNyLGZlSKD31Ks',
    appId: '1:4763739742:web:19c19b4080089c769af6cf',
    messagingSenderId: '4763739742',
    projectId: 'ssoft-estoque',
    authDomain: 'ssoft-estoque.firebaseapp.com',
    databaseURL: 'https://ssoft-estoque-default-rtdb.firebaseio.com',
    storageBucket: 'ssoft-estoque.appspot.com',
    measurementId: 'G-SZZ6YK0EZL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDkF5seFM-qSwkMIzsB-64VF1VbsBk3Mpw',
    appId: '1:4763739742:android:da6efc14cc2965509af6cf',
    messagingSenderId: '4763739742',
    projectId: 'ssoft-estoque',
    databaseURL: 'https://ssoft-estoque-default-rtdb.firebaseio.com',
    storageBucket: 'ssoft-estoque.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDBqt1-bpvIDPZpVtZ1c-WO9LLkJTJjXY4',
    appId: '1:4763739742:ios:d9e3fa2ea40986479af6cf',
    messagingSenderId: '4763739742',
    projectId: 'ssoft-estoque',
    databaseURL: 'https://ssoft-estoque-default-rtdb.firebaseio.com',
    storageBucket: 'ssoft-estoque.appspot.com',
    iosClientId: '4763739742-mr5s5138ql3v59q806tga9m7dtce46oa.apps.googleusercontent.com',
    iosBundleId: 'com.ssoft.ssoftEstoque',
  );
}
