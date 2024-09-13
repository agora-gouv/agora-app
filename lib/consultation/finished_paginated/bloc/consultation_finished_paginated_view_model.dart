import 'package:agora/thematique/bloc/thematique_view_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ConsultationPaginatedViewModel extends Equatable {
  final String id;
  final String title;
  final String coverUrl;
  final ThematiqueViewModel thematique;
  final String? label;
  final String? externalLink;
  final String badgeLabel;
  final Color badgeColor;
  final Color badgeTextColor;

  ConsultationPaginatedViewModel({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.thematique,
    required this.label,
    this.externalLink,
    required this.badgeLabel,
    required this.badgeColor,
    required this.badgeTextColor,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        coverUrl,
        thematique,
        label,
        externalLink,
        badgeLabel,
        badgeColor,
        badgeTextColor,
      ];
}
