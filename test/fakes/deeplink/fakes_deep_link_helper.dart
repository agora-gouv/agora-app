import 'dart:async';

import 'package:agora/common/helper/deep_link_helper.dart';

abstract class FakeNoDeeplinkInStreamHelper extends DeeplinkHelper {
  @override
  Stream<Uri?> getUriLinkStream() {
    return Stream.empty();
  }
}

class FakeNullInitialUriDeeplinkHelper extends FakeNoDeeplinkInStreamHelper {
  @override
  Future<Uri?> getInitUri() async {
    return null;
  }
}

class FakeUnknownHostInitialDeeplinkHelper extends FakeNoDeeplinkInStreamHelper {
  @override
  Future<Uri?> getInitUri() async {
    return Uri.parse("agora://unknown.gouv.fr/");
  }
}

class FakeConsultationCorrectInitialUriDeeplinkHelper extends FakeNoDeeplinkInStreamHelper {
  @override
  Future<Uri?> getInitUri() async {
    return Uri.parse("agora://consultation.gouv.fr/c29255f2-10ca-4be5-aab1-801ea173337c");
  }
}

class FakeConsultationIncorrectInitialUriDeeplinkHelper extends FakeNoDeeplinkInStreamHelper {
  @override
  Future<Uri?> getInitUri() async {
    return Uri.parse("agora://consultation.gouv.fr/c29255f2");
  }
}

class FakeQaGCorrectInitialUriDeeplinkHelper extends FakeNoDeeplinkInStreamHelper {
  @override
  Future<Uri?> getInitUri() async {
    return Uri.parse("agora://qag.gouv.fr/c29255f2-10ca-4be5-aab1-801ea173337c");
  }
}

class FakeQaGIncorrectInitialUriDeeplinkHelper extends FakeNoDeeplinkInStreamHelper {
  @override
  Future<Uri?> getInitUri() async {
    return Uri.parse("agora://qag.gouv.fr/c29255f2");
  }
}

abstract class FakeNoInitialUriHelper extends DeeplinkHelper {
  @override
  Future<Uri?> getInitUri() async {
    return null;
  }
}

class FakeNullUriInStreamHelper extends FakeNoInitialUriHelper {
  @override
  Stream<Uri?> getUriLinkStream() {
    return Stream.value(null);
  }
}

class FakeUnknownHostInStreamHelper extends FakeNoInitialUriHelper {
  @override
  Stream<Uri?> getUriLinkStream() {
    return Stream.value(Uri.parse("agora://unknown.gouv.fr/"));
  }
}

class FakeConsultationStreamCorrectDeeplinkHelper extends FakeNoInitialUriHelper {
  @override
  Stream<Uri?> getUriLinkStream() {
    return Stream.value(Uri.parse("agora://consultation.gouv.fr/c29255f2-10ca-4be5-aab1-801ea17333dd"));
  }
}

class FakeConsultationStreamIncorrectDeeplinkHelper extends FakeNoInitialUriHelper {
  @override
  Stream<Uri?> getUriLinkStream() {
    return Stream.value(Uri.parse("agora://consultation.gouv.fr/c29255f2"));
  }
}

class FakeQaGStreamCorrectDeeplinkHelper extends FakeNoInitialUriHelper {
  @override
  Stream<Uri?> getUriLinkStream() {
    return Stream.value(Uri.parse("agora://qag.gouv.fr/c29255f2-10ca-4be5-aab1-801ea17333dd"));
  }
}

class FakeQaGStreamIncorrectDeeplinkHelper extends FakeNoInitialUriHelper {
  @override
  Stream<Uri?> getUriLinkStream() {
    return Stream.value(Uri.parse("agora://qag.gouv.fr/c29255f2"));
  }
}
