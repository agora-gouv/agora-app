import 'package:flutter/cupertino.dart';

/// see https://pub.dev/packages/responsive_framework
class ResponsiveHelper {
  static const maxScreenSize = 1024.0;

  static const mobileBreakPoint = 450.0;
  static const tabletBreakPoint = 800.0;
  static const desktopBreakPoint = 1920.0;

  static bool isLargerThanMobile(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide > 450;
  }
}
