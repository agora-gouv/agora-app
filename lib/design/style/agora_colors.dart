import 'package:flutter/painting.dart';

class AgoraColors {
  static const Color primaryGrey = Color(0xFF1A1A1A);
  static const Color primaryGreyOpacity90 = Color(0xE61A1A1A);
  static const Color primaryGreyOpacity80 = Color(0xCC1A1A1A);
  static const Color primaryGreyOpacity70 = Color(0xB31A1A1A);
  static const Color potBlack = Color(0xFF161616);
  static const Color border = Color(0x30000000);
  static const Color rhineCastle = Color(0xFF5F5F5F);
  static const Color overlay = Color(0x80D6D6D6);
  static const Color stoicWhite = Color(0x80DFE6FF);
  static const Color brilliantWhite = Color(0xFFE8EDFF);
  static const Color gravelFint = Color(0xFFBBBBBB);
  static const Color orochimaru = Color(0xFFD9D9D9);
  static const Color steam = Color(0xFFDDDDDD);
  static const Color white = Color(0xFFFFFFFF);
  static const Color whiteOpacity90 = Color(0xD9FFFFFF);
  static const Color doctor = Color(0xFFF9F9F9);
  static const Color cascadingWhite = Color(0xFFF6F6F6);
  static const Color superSilver = Color(0xFFEEEEEE);
  static const Color background = Color(0xFFF5F5F5);
  static const Color invertedBlueFrance = Color(0xFFF5F5FE);
  static const Color mountainLakeAzure = Color(0xFF51C0A6);
  static const Color primaryBlue = Color(0xFF000091);
  static const Color primaryBlueOpacity50 = Color(0x80000091);
  static const Color primaryBlueOpacity10 = Color(0x1A000091);
  static const Color blue525 = Color(0xFF6A6AF4);
  static const Color blue525opacity06 = Color(0x0F6A6AF4);
  static const Color grey425 = Color(0xFF666666);
  static const Color grey425Opacity40 = Color(0x66666666);
  static const Color transparent = Color(0x00000000);
  static const Color divider = Color(0x1A000000);
  static const Color fluorescentRed = Color(0xFFFF5655);
  static const Color red = Color(0xFFCE0500);
  static const Color lightRedOpacity19 = Color(0x30CB2C31);
  static const Color lightRedOpacity4 = Color(0x0ACB2C31);
  static const Color brun = Color(0xFF716043);
  static const Color lightBrun = Color(0xFFFEECC2);
  static const Color blur = Color(0x123D3C49);

  // couleur de pastille
  static const Color mintZest = Color(0xFFCFFCD9);
  static const Color icyPlains = Color(0xFFCFDEFC);
  static const Color bolognaSausage = Color(0xFFFCCFDD);
  static const Color stereotypicalDuck = Color(0xFFFCF7CF);
  static const Color water = Color(0xFFCFF6FC);
  static const Color fairIvory = Color(0xFFFCE7CF);
  static const Color mousseAuxPruneaux = Color(0xFFE8CFFC);
  static const Color crystalFalls = Color(0xFFE1E7F3);
  static const Color hintColor = Color(0xFF767676);
  static const Color borderHintColor = Color(0xFF8D8D8D);
}

class AgoraVideoProgressColors {
  AgoraVideoProgressColors({
    Color playedColor = AgoraColors.primaryBlue,
    Color bufferedColor = AgoraColors.primaryBlueOpacity50,
    Color handleColor = const Color.fromRGBO(200, 200, 200, 1.0),
    Color backgroundColor = const Color.fromRGBO(200, 200, 200, 0.5),
  })  : playedPaint = Paint()..color = playedColor,
        bufferedPaint = Paint()..color = bufferedColor,
        handlePaint = Paint()..color = handleColor,
        backgroundPaint = Paint()..color = backgroundColor;

  final Paint playedPaint;
  final Paint bufferedPaint;
  final Paint handlePaint;
  final Paint backgroundPaint;
}
