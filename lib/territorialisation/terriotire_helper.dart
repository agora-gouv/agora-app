import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/territorialisation/territoire.dart';
import 'package:flutter/material.dart';

Color getTerritoireBadgeColor(TerritoireType type) {
  switch (type) {
    case TerritoireType.national:
      return AgoraColors.badgeNational;
    case TerritoireType.regional:
      return AgoraColors.badgeRegional;
    case TerritoireType.departemental:
      return AgoraColors.badgeDepartemental;
  }
}

Color getTerritoireBadgeTexteColor(TerritoireType type) {
  switch (type) {
    case TerritoireType.national:
      return AgoraColors.badgeNationalTexte;
    case TerritoireType.regional:
      return AgoraColors.badgeRegionalTexte;
    case TerritoireType.departemental:
      return AgoraColors.badgeDepartementalTexte;
  }
}
