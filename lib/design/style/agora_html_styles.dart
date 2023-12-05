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
    final textScaler = MediaQuery.of(context).textScaler;
    return {
      "body": AgoraHtmlStyles.bodyStyle(textScaler),
      "ul": AgoraHtmlStyles.bodyStyle(textScaler),
      "ol": AgoraHtmlStyles.bodyStyle(textScaler),
      "li": AgoraHtmlStyles.bodyStyle(textScaler),
      "b": AgoraHtmlStyles.boldStyle(textScaler),
      "h1": AgoraHtmlStyles.h1Style(textScaler),
      "span": AgoraHtmlStyles.spanStyle(textScaler),
    };
  }

  static Style bodyStyle(TextScaler textScaler) => Style(
        fontFamily: marianne,
        fontWeight: light,
        fontSize: FontSize(textScaler.scale(14.0)),
        color: AgoraColors.primaryGrey,
        lineHeight: LineHeight(height),
        padding: HtmlPaddings.zero,
        margin: Margins.zero,
      );

  static Style boldStyle(TextScaler textScaler) => Style(
        fontFamily: marianne,
        fontWeight: medium,
        fontSize: FontSize(textScaler.scale(14.0)),
        color: AgoraColors.primaryGrey,
        lineHeight: LineHeight(height),
        padding: HtmlPaddings.zero,
        margin: Margins.zero,
      );

  static Style h1Style(TextScaler textScaler) => Style(
        fontFamily: marianne,
        fontWeight: bold,
        fontSize: FontSize(textScaler.scale(16.0)),
        color: AgoraColors.primaryBlue,
        lineHeight: LineHeight(height),
        padding: HtmlPaddings.zero,
        margin: Margins.zero,
      );

  static Style spanStyle(TextScaler textScaler) => Style(
        fontFamily: marianne,
        fontWeight: bold,
        fontSize: FontSize(textScaler.scale(14.0)),
        color: AgoraColors.primaryBlue,
        lineHeight: LineHeight(height),
        padding: HtmlPaddings.zero,
        margin: Margins.zero,
      );
}
