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
        return windows;
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBtGZyqC9rjT-wQZwHnC0UauYx3Mk7u6jk',
    appId: '1:1069697409641:android:7ebb9cb50d7682188a78f8',
    messagingSenderId: '1069697409641',
    projectId: 'bloodbank-7a8d7',
    storageBucket: 'bloodbank-7a8d7.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAXWoPZ1O-1X0IGyzDtawVLc2XaQL2BTWY',
    appId: '1:1069697409641:web:28c669762310f0d68a78f8',
    messagingSenderId: '1069697409641',
    projectId: 'bloodbank-7a8d7',
    authDomain: 'bloodbank-7a8d7.firebaseapp.com',
    storageBucket: 'bloodbank-7a8d7.firebasestorage.app',
    measurementId: 'G-8FRC9494EF',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAu0Q6c3KGbpw5yjnDyU0gYhT_hs1j1UMo',
    appId: '1:1069697409641:ios:3cc8f9b50d550c1e8a78f8',
    messagingSenderId: '1069697409641',
    projectId: 'bloodbank-7a8d7',
    storageBucket: 'bloodbank-7a8d7.firebasestorage.app',
    iosClientId: '1069697409641-o7gjccpboropf7ghe00lre8mp5g99o2k.apps.googleusercontent.com',
    iosBundleId: 'com.smartbloodcare.smartbloodcare',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAu0Q6c3KGbpw5yjnDyU0gYhT_hs1j1UMo',
    appId: '1:1069697409641:ios:3cc8f9b50d550c1e8a78f8',
    messagingSenderId: '1069697409641',
    projectId: 'bloodbank-7a8d7',
    storageBucket: 'bloodbank-7a8d7.firebasestorage.app',
    iosClientId: '1069697409641-o7gjccpboropf7ghe00lre8mp5g99o2k.apps.googleusercontent.com',
    iosBundleId: 'com.smartbloodcare.smartbloodcare',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAXWoPZ1O-1X0IGyzDtawVLc2XaQL2BTWY',
    appId: '1:1069697409641:web:7cb22600ef710b188a78f8',
    messagingSenderId: '1069697409641',
    projectId: 'bloodbank-7a8d7',
    authDomain: 'bloodbank-7a8d7.firebaseapp.com',
    storageBucket: 'bloodbank-7a8d7.firebasestorage.app',
    measurementId: 'G-W9WFY46G1H',
  );

}