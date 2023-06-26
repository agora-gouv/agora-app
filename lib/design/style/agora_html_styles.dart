import 'package:agora/design/style/agora_colors.dart';
import 'package:flutter/painting.dart';
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

  static Map<String, Style> htmlStyle = {
    "body": AgoraHtmlStyles.bodyStyle,
    "b": AgoraHtmlStyles.boldStyle,
    "h1": AgoraHtmlStyles.h1Style,
    "span": AgoraHtmlStyles.spanStyle,
  };

  static Style bodyStyle = Style(
    fontFamily: marianne,
    fontWeight: light,
    fontSize: FontSize(14.0),
    color: AgoraColors.primaryGrey,
    lineHeight: LineHeight(height),
    padding: EdgeInsets.zero,
    margin: Margins.zero,
  );

  static Style boldStyle = Style(
    fontFamily: marianne,
    fontWeight: medium,
    fontSize: FontSize(14.0),
    color: AgoraColors.primaryGrey,
    lineHeight: LineHeight(height),
    padding: EdgeInsets.zero,
    margin: Margins.zero,
  );

  static Style h1Style = Style(
    fontFamily: marianne,
    fontWeight: bold,
    fontSize: FontSize(16.0),
    color: AgoraColors.primaryBlue,
    lineHeight: LineHeight(height),
    padding: EdgeInsets.zero,
    margin: Margins.zero,
  );

  static Style spanStyle = Style(
    fontFamily: marianne,
    fontWeight: bold,
    fontSize: FontSize(14.0),
    color: AgoraColors.primaryBlue,
    lineHeight: LineHeight(height),
    padding: EdgeInsets.zero,
    margin: Margins.zero,
  );
}
