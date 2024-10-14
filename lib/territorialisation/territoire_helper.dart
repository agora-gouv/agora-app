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

Territoire getTerritoireFromReferentiel(List<Territoire> referentiel, String territoire) {
  for (var territoireFromReferentiel in referentiel) {
    if (territoireFromReferentiel.label == territoire) {
      return territoireFromReferentiel;
    }
    if (territoireFromReferentiel is Region && territoireFromReferentiel.departements.isNotEmpty) {
      for (var departement in territoireFromReferentiel.departements) {
        if (departement.label == territoire) {
          return departement;
        }
      }
    }
  }
  return Departement(label: '', codePostal: '');
}

Region getRegionFromDepartement(Departement departement, List<Territoire> referentiel) {
  for (var territoireFromReferentiel in referentiel) {
    if (territoireFromReferentiel is Region && territoireFromReferentiel.departements.isNotEmpty) {
      for (var departementFromRegion in territoireFromReferentiel.departements) {
        if (departementFromRegion.label == departement.label) {
          return territoireFromReferentiel;
        }
      }
    }
  }
  return Region(label: '', departements: []);
}

String getCodePostalFromDepartementLabel(String departementLabel, List<Territoire> referentiel) {
  for (var territoireFromReferentiel in referentiel) {
    if (territoireFromReferentiel is Region && territoireFromReferentiel.departements.isNotEmpty) {
      for (var departement in territoireFromReferentiel.departements) {
        if (departement.label == departementLabel) {
          return departement.codePostal;
        }
      }
    }
  }
  return '';
}

List<Departement> getDepartementFromReferentiel(List<Territoire> referentiel) {
  final List<Departement> departements = [];
  for (var territoireFromReferentiel in referentiel) {
    if (territoireFromReferentiel is Region && territoireFromReferentiel.departements.isNotEmpty) {
      for (var departement in territoireFromReferentiel.departements) {
        departements.add(departement);
      }
    }
  }
  return departements;
}

Departement? getDepartementByCodePostal(String code, List<Territoire> referentiel) {
  if (code == "99") {
    return Departement(label: "Hors-de-France", codePostal: "99");
  }
  for (var territoireFromReferentiel in referentiel) {
    if (territoireFromReferentiel is Region && territoireFromReferentiel.departements.isNotEmpty) {
      for (var departement in territoireFromReferentiel.departements) {
        if (departement.codePostal == code) {
          return departement;
        }
      }
    }
  }
  return null;
}
