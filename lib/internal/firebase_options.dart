import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:quran/internal/gen/default.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: Default.keyAndApi,
    appId: Default.keyAndApp,
    messagingSenderId: Default.keyAndMsg,
    projectId: Default.keyAndPrj,
    storageBucket: Default.keyAndStg
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: Default.keyIosApi,
    appId: Default.keyIosApp,
    messagingSenderId: Default.keyIosMsg,
    projectId: Default.keyIosPrj,
    storageBucket: Default.keyIosStg,
    iosClientId: Default.keyIosClt,
    iosBundleId: Default.keyIosBnd,
  );
}
