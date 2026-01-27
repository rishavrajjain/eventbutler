import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  /// Android config derived from android/app/google-services.json
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCHXiikmoAVEY6_O1_VoD7ZqcS4COdXR6Y',
    appId: '1:131165147482:android:40a7efb52306dfa574a363',
    messagingSenderId: '131165147482',
    projectId: 'recipebutler-fd32c',
    storageBucket: 'recipebutler-fd32c.firebasestorage.app',
  );

  /// iOS config derived from ios/Runner/GoogleService-Info.plist
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBC0gXSC53aVXzEe_IRhu-IMElnPf4zo3s',
    appId: '1:131165147482:ios:aef2980e27f7649974a363',
    messagingSenderId: '131165147482',
    projectId: 'recipebutler-fd32c',
    storageBucket: 'recipebutler-fd32c.firebasestorage.app',
    iosBundleId: 'com.example.recipeButler',
    iosClientId:
        '131165147482-fhe3a5rul5c42pqm9neba6nqd6t6v0d4.apps.googleusercontent.com',
  );

  /// Web config provided by Firebase console.
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCJ2_mXvNwL0W0neKj4DqemIPh2mU108gA',
    appId: '1:131165147482:web:9ef19eebac26ed4374a363',
    messagingSenderId: '131165147482',
    projectId: 'recipebutler-fd32c',
    authDomain: 'recipebutler-fd32c.firebaseapp.com',
    storageBucket: 'recipebutler-fd32c.firebasestorage.app',
    measurementId: 'G-XBYL5KJL98',
  );
}
