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
    apiKey: 'AIzaSyD-88MXYqJhXdw7BRCZwHzYB-YEz956P7Q',
    appId: '1:968848509062:web:83517f22e07c917f60a907',
    messagingSenderId: '968848509062',
    projectId: 'activity-80026',
    authDomain: 'activity-80026.firebaseapp.com',
    storageBucket: 'activity-80026.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAQFzt7ZAXxbz-Iiyq_SKlw87m0mx1w-Fc',
    appId: '1:968848509062:android:334e913d5d325f5460a907',
    messagingSenderId: '968848509062',
    projectId: 'activity-80026',
    storageBucket: 'activity-80026.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDNFlKPDX5_7ir3cr6FqaTYBuyU2WEvL4A',
    appId: '1:968848509062:ios:9be3af60d24c179d60a907',
    messagingSenderId: '968848509062',
    projectId: 'activity-80026',
    storageBucket: 'activity-80026.appspot.com',
    iosBundleId: 'com.example.activity',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDNFlKPDX5_7ir3cr6FqaTYBuyU2WEvL4A',
    appId: '1:968848509062:ios:189236a8ecbfaa8f60a907',
    messagingSenderId: '968848509062',
    projectId: 'activity-80026',
    storageBucket: 'activity-80026.appspot.com',
    iosBundleId: 'com.example.activity.RunnerTests',
  );
}
