import 'package:flutter/cupertino.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// see https://pub.dev/packages/responsive_framework
class ResponsiveHelper {
  static const maxScreenSize = 1024.0;

  static const mobileBreakPoint = 450.0;
  static const tabletBreakPoint = 800.0;
  static const desktopBreakPoint = 1920.0;

  static bool isLargerThanMobile({required BuildContext context}) {
    return ResponsiveBreakpoints.of(context).largerThan(MOBILE);
  }

  static bool isLargerThanTablet({required BuildContext context}) {
    return ResponsiveBreakpoints.of(context).largerThan(TABLET);
  }

  static bool isLargerThanMaxScreen({required BuildContext context}) {
    return MediaQuery.of(context).size.width > maxScreenSize;
  }
}
