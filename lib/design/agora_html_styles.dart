import 'package:agora/design/agora_colors.dart';
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
  };

  static Style bodyStyle = Style(
    fontFamily: marianne,
    fontWeight: light,
    fontSize: FontSize(14.0),
    color: AgoraColors.primaryGrey,
    lineHeight: LineHeight(height),
  );

  static Style boldStyle = Style(
    fontFamily: marianne,
    fontWeight: medium,
    fontSize: FontSize(14.0),
    color: AgoraColors.primaryGrey,
    lineHeight: LineHeight(height),
  );
}
