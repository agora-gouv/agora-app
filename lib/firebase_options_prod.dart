import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class ProdFirebaseOptions {
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
    apiKey: 'AIzaSyCA8FxjUTLzhHEhVn3Kf_7GH-flqerqSro',
    appId: '1:575887202735:android:af7eba78e9331af470f75a',
    messagingSenderId: '575887202735',
    projectId: 'agora-prod-83c6c',
    storageBucket: 'agora-prod-83c6c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAJDhzWPBlmWohVFQ-1kTh_j2zVPND0ROE',
    appId: '1:575887202735:ios:6a8c912c945636ba70f75a',
    messagingSenderId: '575887202735',
    projectId: 'agora-prod-83c6c',
    storageBucket: 'agora-prod-83c6c.appspot.com',
    androidClientId: '575887202735-lteg7ob4nppur417c1jh09kdtseoq51i.apps.googleusercontent.com',
    iosClientId: '575887202735-c4i0ir09bn06l8u2sl57nto9sknjl0ed.apps.googleusercontent.com',
    iosBundleId: 'fr.social.gouv.agora.debug',
  );
}
