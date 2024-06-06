import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
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

  static Map<String, Style> htmlStyle(BuildContext context, double fontSize, TextAlign textAlign) {
    return {
      "html": Style(textAlign: textAlign),
      "body": AgoraHtmlStyles._bodyStyle(fontSize),
      "ul": AgoraHtmlStyles._listStyle(fontSize),
      "ol": AgoraHtmlStyles._bodyStyle(fontSize),
      "li": AgoraHtmlStyles._bodyStyle(fontSize),
      "b": AgoraHtmlStyles._boldStyle(fontSize),
      "h1": AgoraHtmlStyles._h1Style(fontSize),
      "span": AgoraHtmlStyles._spanStyle(fontSize),
      "a": AgoraHtmlStyles._linkStyle(fontSize),
    };
  }

  static Style _bodyStyle(double fontSize) => Style(
        fontFamily: marianne,
        fontWeight: light,
        fontSize: FontSize(fontSize),
        color: AgoraColors.primaryGrey,
        textDecorationColor: AgoraColors.primaryBlue,
        lineHeight: LineHeight(height),
        padding: HtmlPaddings.zero,
        margin: Margins.zero,
      );

  static Style _listStyle(double fontSize) => Style(
        fontFamily: marianne,
        fontWeight: light,
        fontSize: FontSize(fontSize),
        color: AgoraColors.primaryGrey,
        textDecorationColor: AgoraColors.primaryBlue,
        lineHeight: LineHeight(height),
        padding: HtmlPaddings(left: HtmlPadding(AgoraSpacings.x0_75)),
        margin: Margins.zero,
      );

  static Style _linkStyle(double fontSize) => Style(
        fontFamily: marianne,
        fontWeight: light,
        fontSize: FontSize(fontSize),
        color: AgoraColors.primaryBlue,
        lineHeight: LineHeight(height),
        padding: HtmlPaddings.zero,
        margin: Margins.zero,
      );

  static Style _boldStyle(double fontSize) => Style(
        fontFamily: marianne,
        fontWeight: medium,
        fontSize: FontSize(fontSize),
        color: AgoraColors.primaryGrey,
        lineHeight: LineHeight(height),
        padding: HtmlPaddings.zero,
        margin: Margins.zero,
      );

  static Style _h1Style(double fontSize) => Style(
        fontFamily: marianne,
        fontWeight: bold,
        fontSize: FontSize(fontSize),
        color: AgoraColors.primaryBlue,
        lineHeight: LineHeight(height),
        padding: HtmlPaddings.zero,
        margin: Margins.zero,
      );

  static Style _spanStyle(double fontSize) => Style(
        fontFamily: marianne,
        fontWeight: bold,
        fontSize: FontSize(fontSize),
        color: AgoraColors.primaryBlue,
        lineHeight: LineHeight(height),
        padding: HtmlPaddings.zero,
        margin: Margins.zero,
      );
}
