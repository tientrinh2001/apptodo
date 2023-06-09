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
    apiKey: 'AIzaSyDhatwcd4rxQxMZGGPSXxGvTb0njTJDcn4',
    appId: '1:326664176752:web:a01eebcc25d5e7a17e20b5',
    messagingSenderId: '326664176752',
    projectId: 'todo-minimalist-33a97',
    authDomain: 'todo-minimalist-33a97.firebaseapp.com',
    storageBucket: 'todo-minimalist-33a97.appspot.com',
    measurementId: 'G-MLTBVS8HWZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB80BAA5LgntOjA95Gjib7SNieDDOxudIs',
    appId: '1:326664176752:android:f1128f1fc8faad0a7e20b5',
    messagingSenderId: '326664176752',
    projectId: 'todo-minimalist-33a97',
    storageBucket: 'todo-minimalist-33a97.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyArYqfGfIxBfcyFhp0sePctwl3UYw3m7NU',
    appId: '1:326664176752:ios:e5e18bd63919bd217e20b5',
    messagingSenderId: '326664176752',
    projectId: 'todo-minimalist-33a97',
    storageBucket: 'todo-minimalist-33a97.appspot.com',
    iosClientId: '326664176752-kntbahedkuj9kmov0dgl98niduhllmum.apps.googleusercontent.com',
    iosBundleId: 'com.example.todoMinimalist',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyArYqfGfIxBfcyFhp0sePctwl3UYw3m7NU',
    appId: '1:326664176752:ios:e5e18bd63919bd217e20b5',
    messagingSenderId: '326664176752',
    projectId: 'todo-minimalist-33a97',
    storageBucket: 'todo-minimalist-33a97.appspot.com',
    iosClientId: '326664176752-kntbahedkuj9kmov0dgl98niduhllmum.apps.googleusercontent.com',
    iosBundleId: 'com.example.todoMinimalist',
  );
}
