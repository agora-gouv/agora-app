import 'dart:async';

import 'package:uni_links/uni_links.dart';

abstract class DeeplinkHelper {
  Future<Uri?> getInitUri();

  Stream<Uri?> getUriLinkStream();
}

class DeeplinkImplHelper extends DeeplinkHelper {
  static const String consultationHost = "consultation.gouv.fr";
  static const String qagHost = "qag.gouv.fr";

  @override
  Future<Uri?> getInitUri() async {
    return await getInitialUri();
  }

  @override
  Stream<Uri?> getUriLinkStream() {
    return uriLinkStream;
  }
}
