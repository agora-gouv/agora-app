import 'package:equatable/equatable.dart';

class QagThemeHebdo extends Equatable {
  final String titre;
  final String sousTitre;
  final String periode;
  final String theme;
  final String avatarUrl;
  final String nom;
  final String fonction;
  final List<String> prochainsThemes;
  final String titreCompteur;
  final String dateFinTheme;
  final String dateDebutTheme;

  QagThemeHebdo({
    required this.titre,
    required this.sousTitre,
    required this.periode,
    required this.theme,
    required this.avatarUrl,
    required this.nom,
    required this.fonction,
    required this.prochainsThemes,
    required this.titreCompteur,
    required this.dateFinTheme,
    required this.dateDebutTheme,
  });

  @override
  List<Object?> get props => [
        titre,
        sousTitre,
        periode,
        theme,
        avatarUrl,
        nom,
        fonction,
        prochainsThemes,
        titreCompteur,
        dateFinTheme,
        dateDebutTheme,
      ];
}
