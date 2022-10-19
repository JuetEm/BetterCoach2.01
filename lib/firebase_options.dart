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

  // 테스트 서버 설정
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDwOr0n-ZLITyT6s-Kw-cUMI7ZZ1BnWSWE',
    appId: '1:417922293739:web:ab19a65f42557996e103ae',
    messagingSenderId: '417922293739',
    projectId: 'bettercoach-d6c79',
    authDomain: 'bettercoach-d6c79.firebaseapp.com',
    storageBucket: 'bettercoach-d6c79.appspot.com',
    measurementId: 'G-3TDMFTD85Y',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDZ-1Vn33J6lz_pDD4fE3LFLWno-BOReXw',
    appId: '1:417922293739:android:8a0a38908d1de53de103ae',
    messagingSenderId: '417922293739',
    projectId: 'bettercoach-d6c79',
    storageBucket: 'bettercoach-d6c79.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAORA1EgKjDgyhzaKZtJNbxdasBF1h5Jhs',
    appId: '1:417922293739:ios:6c7b7f9ac10598e7e103ae',
    messagingSenderId: '417922293739',
    projectId: 'bettercoach-d6c79',
    storageBucket: 'bettercoach-d6c79.appspot.com',
    iosClientId:
        '417922293739-u2a892q9iip44gobrqt8d4rqa3vref58.apps.googleusercontent.com',
    iosBundleId: 'com.example.webProject',
  );

  // // 개발 서버 설정
  // static const FirebaseOptions web = FirebaseOptions(
  //   apiKey: 'AIzaSyBaLXrANizji4uU74knRudK7hAlOrt-Jfw',
  //   appId: '1:980690811295:web:1ce0edac8212fcf98225aa',
  //   messagingSenderId: '980690811295',
  //   projectId: 'webproject-48ca4',
  //   authDomain: 'webproject-48ca4.firebaseapp.com',
  //   storageBucket: 'webproject-48ca4.appspot.com',
  //   measurementId: 'G-MW3Z1TGMSL',
  // );

  // static const FirebaseOptions android = FirebaseOptions(
  //   apiKey: 'AIzaSyC6Tasv8GrCTKvcI6J3O8o9YPBnfcx34t4',
  //   appId: '1:980690811295:android:5f257f5558c310ce8225aa',
  //   messagingSenderId: '980690811295',
  //   projectId: 'webproject-48ca4',
  //   storageBucket: 'webproject-48ca4.appspot.com',
  // );

  // static const FirebaseOptions ios = FirebaseOptions(
  //   apiKey: 'AIzaSyAcUR3PRm-spuxKgKqREWs4ZiaRTWoOgMM',
  //   appId: '1:980690811295:ios:d846e11fb5f9b4718225aa',
  //   messagingSenderId: '980690811295',
  //   projectId: 'webproject-48ca4',
  //   storageBucket: 'webproject-48ca4.appspot.com',
  //   iosClientId:
  //       '980690811295-iavlhtq0ts0mdp4ljn9sh2klpuslt2si.apps.googleusercontent.com',
  //   iosBundleId: 'com.example.webProject',
  // );
}
