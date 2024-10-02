import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/territorialisation/departement.dart';
import 'package:agora/territorialisation/region.dart';
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

Territoire getTerritoireFromReferentiel(List<Region> referentiel, String territoire) {
  for (var territoireFromReferentiel in referentiel) {
    if (territoireFromReferentiel.label == territoire) {
      return territoireFromReferentiel;
    }
    if (territoireFromReferentiel.departements.isNotEmpty) {
      for (var departement in territoireFromReferentiel.departements) {
        if (departement.label == territoire) {
          return departement;
        }
      }
    }
  }
  return Departement(label: '');
}
