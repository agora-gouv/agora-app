import 'dart:async';

import 'package:agora/common/helper/deep_link_helper.dart';

class FakeConsultationInitialUriDeeplinkHelper extends DeeplinkHelper {
  @override
  Future<Uri?> getInitUri() async {
    return Uri.parse("agora://consultation.gouv.fr/c29255f2-10ca-4be5-aab1-801ea173337c");
  }

  @override
  Stream<Uri?> getUriLinkStream() {
    return Stream.empty();
  }
}

class FakeConsultationStreamDeeplinkHelper extends DeeplinkHelper {
  @override
  Future<Uri?> getInitUri() async {
    return null;
  }

  @override
  Stream<Uri?> getUriLinkStream() {
    return Stream.value(Uri.parse("agora://consultation.gouv.fr/c29255f2-10ca-4be5-aab1-801ea17333dd"));
  }
}
