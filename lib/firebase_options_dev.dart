import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DevFirebaseOptions {
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
    apiKey: 'AIzaSyC5faCHfTrvzyutXnNXp-WuQiMWO7j2iFE',
    appId: '1:128862173768:android:ca1a49d2af950684b3f67d',
    messagingSenderId: '128862173768',
    projectId: 'agora-dev-6c6bd',
    storageBucket: 'agora-dev-6c6bd.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCTPL4NDF8KPVbGg86uv-juz8Sgg5-GOes',
    appId: '1:128862173768:ios:23c90a64efbf303db3f67d',
    messagingSenderId: '128862173768',
    projectId: 'agora-dev-6c6bd',
    storageBucket: 'agora-dev-6c6bd.appspot.com',
    iosClientId: '128862173768-gc2r7o18hdg95r5vd8engfsl46bmv8et.apps.googleusercontent.com',
    iosBundleId: 'fr.social.gouv.agora.debug',
  );
}
