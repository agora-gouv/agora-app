import 'package:agora/design/agora_colors.dart';
import 'package:flutter/painting.dart';

class AgoraTextStyles {
  static const marianne = "Marianne";
  static const height = 1.5;

  static const extraBold = FontWeight.w900;
  static const bold = FontWeight.w800;
  static const medium = FontWeight.w700;
  static const regular = FontWeight.w500;
  static const light = FontWeight.w400;
  static const thin = FontWeight.w300;

  static const TextStyle medium23 = TextStyle(
    fontFamily: marianne,
    fontWeight: medium,
    fontSize: 23.0,
    color: AgoraColors.primaryGrey,
    height: height,
  );

  static const TextStyle medium20 = TextStyle(
    fontFamily: marianne,
    fontWeight: medium,
    fontSize: 20.0,
    color: AgoraColors.primaryGrey,
    height: height,
  );

  static const TextStyle medium19 = TextStyle(
    fontFamily: marianne,
    fontWeight: medium,
    fontSize: 19.0,
    color: AgoraColors.primaryGrey,
    height: height,
  );

  static const TextStyle medium18 = TextStyle(
    fontFamily: marianne,
    fontWeight: medium,
    fontSize: 18.0,
    color: AgoraColors.primaryGrey,
    height: height,
  );
  static const TextStyle medium17 = TextStyle(
    fontFamily: marianne,
    fontWeight: medium,
    fontSize: 17.0,
    color: AgoraColors.primaryGrey,
    height: height,
  );

  static const TextStyle medium16 = TextStyle(
    fontFamily: marianne,
    fontWeight: medium,
    fontSize: 16.0,
    color: AgoraColors.primaryGrey,
    height: height,
  );

  static const TextStyle medium14 = TextStyle(
    fontFamily: marianne,
    fontWeight: medium,
    fontSize: 14.0,
    color: AgoraColors.primaryGrey,
    height: height,
  );

  static const TextStyle medium12 = TextStyle(
    fontFamily: marianne,
    fontWeight: medium,
    fontSize: 12.0,
    color: AgoraColors.primaryGrey,
    height: height,
  );

  static const TextStyle regular13 = TextStyle(
    fontFamily: marianne,
    fontWeight: regular,
    fontSize: 13.0,
    color: AgoraColors.primaryGrey,
    height: height,
  );

  static const TextStyle light16 = TextStyle(
    fontFamily: marianne,
    fontWeight: light,
    fontSize: 16.0,
    color: AgoraColors.primaryGrey,
    height: height,
  );

  static const TextStyle light16Underline = TextStyle(
    fontFamily: marianne,
    fontWeight: light,
    fontSize: 16.0,
    color: AgoraColors.primaryGrey,
    height: height,
    decoration: TextDecoration.underline,
  );

  static const TextStyle light14 = TextStyle(
    fontFamily: marianne,
    fontWeight: light,
    fontSize: 14.0,
    color: AgoraColors.primaryGrey,
    height: height,
  );

  static const TextStyle lightItalic14 = TextStyle(
    fontFamily: marianne,
    fontWeight: light,
    fontStyle: FontStyle.italic,
    fontSize: 14.0,
    color: AgoraColors.primaryGrey,
    height: height,
  );

  static const TextStyle regularItalic14 = TextStyle(
    fontFamily: marianne,
    fontWeight: regular,
    fontStyle: FontStyle.italic,
    fontSize: 14.0,
    color: AgoraColors.primaryGrey,
    height: height,
  );

  static TextStyle primaryButton = TextStyle(
    fontFamily: marianne,
    fontWeight: medium,
    fontSize: 16.0,
    foreground: Paint()..color = AgoraColors.invertedBlueFrance,
  );

  static TextStyle lightGreyButton = TextStyle(
    fontFamily: marianne,
    fontWeight: medium,
    fontSize: 16.0,
    foreground: Paint()..color = AgoraColors.potBlack,
  );
}
