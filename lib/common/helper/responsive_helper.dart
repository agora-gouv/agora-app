import 'package:flutter/cupertino.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// see https://pub.dev/packages/responsive_framework
class ResponsiveHelper {
  static const maxScreenSize = 1024.0;

  static bool isLargerThanMobile({required BuildContext context}) {
    return ResponsiveBreakpoints.of(context).largerThan(MOBILE);
  }
}
