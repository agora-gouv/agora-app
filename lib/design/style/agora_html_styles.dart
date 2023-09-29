import 'package:agora/design/style/agora_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class AgoraHtmlStyles {
  static const marianne = "Marianne";
  static const height = 1.5;

  static const extraBold = FontWeight.w900;
  static const bold = FontWeight.w800;
  static const medium = FontWeight.w700;
  static const regular = FontWeight.w500;
  static const light = FontWeight.w400;
  static const thin = FontWeight.w300;

  static Map<String, Style> htmlStyle(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;
    return {
      "body": AgoraHtmlStyles.bodyStyle(scaleFactor),
      "ul": AgoraHtmlStyles.bodyStyle(scaleFactor),
      "ol": AgoraHtmlStyles.bodyStyle(scaleFactor),
      "li": AgoraHtmlStyles.bodyStyle(scaleFactor),
      "b": AgoraHtmlStyles.boldStyle(scaleFactor),
      "h1": AgoraHtmlStyles.h1Style(scaleFactor),
      "span": AgoraHtmlStyles.spanStyle(scaleFactor),
    };
  }

  static Style bodyStyle(double scaleFactor) => Style(
        fontFamily: marianne,
        fontWeight: light,
        fontSize: FontSize(14.0 * scaleFactor),
        color: AgoraColors.primaryGrey,
        lineHeight: LineHeight(height),
        padding: EdgeInsets.zero,
        margin: Margins.zero,
      );

  static Style boldStyle(double scaleFactor) => Style(
        fontFamily: marianne,
        fontWeight: medium,
        fontSize: FontSize(14.0 * scaleFactor),
        color: AgoraColors.primaryGrey,
        lineHeight: LineHeight(height),
        padding: EdgeInsets.zero,
        margin: Margins.zero,
      );

  static Style h1Style(double scaleFactor) => Style(
        fontFamily: marianne,
        fontWeight: bold,
        fontSize: FontSize(16.0 * scaleFactor),
        color: AgoraColors.primaryBlue,
        lineHeight: LineHeight(height),
        padding: EdgeInsets.zero,
        margin: Margins.zero,
      );

  static Style spanStyle(double scaleFactor) => Style(
        fontFamily: marianne,
        fontWeight: bold,
        fontSize: FontSize(14.0 * scaleFactor),
        color: AgoraColors.primaryBlue,
        lineHeight: LineHeight(height),
        padding: EdgeInsets.zero,
        margin: Margins.zero,
      );
}
