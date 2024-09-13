import 'package:agora/thematique/bloc/thematique_view_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ConsultationViewModel extends Equatable {
  final String id;
  final String slug;
  final String title;
  final String coverUrl;
  final ThematiqueViewModel thematique;
  final String? label;
  final String badgeLabel;
  final Color badgeColor;
  final Color badgeTextColor;

  ConsultationViewModel({
    required this.id,
    required this.slug,
    required this.title,
    required this.coverUrl,
    required this.thematique,
    required this.label,
    required this.badgeLabel,
    required this.badgeColor,
    required this.badgeTextColor,
  });

  @override
  List<Object?> get props => [
        id,
        slug,
        title,
        coverUrl,
        thematique,
        label,
        badgeLabel,
        badgeColor,
        badgeTextColor,
      ];
}

class ConsultationOngoingViewModel extends ConsultationViewModel {
  final String endDate;

  ConsultationOngoingViewModel({
    required super.id,
    required super.slug,
    required super.title,
    required super.coverUrl,
    required super.thematique,
    required super.label,
    required super.badgeLabel,
    required super.badgeColor,
    required super.badgeTextColor,
    required this.endDate,
  });

  @override
  List<Object?> get props => [...super.props, endDate];
}

class ConsultationFinishedViewModel extends ConsultationViewModel {
  ConsultationFinishedViewModel({
    required super.id,
    required super.slug,
    required super.title,
    required super.coverUrl,
    required super.thematique,
    required super.label,
    required super.badgeLabel,
    required super.badgeColor,
    required super.badgeTextColor,
  });

  @override
  List<Object?> get props => [...super.props];
}

class ConsultationAnsweredViewModel extends ConsultationViewModel {
  ConsultationAnsweredViewModel({
    required super.id,
    required super.slug,
    required super.title,
    required super.coverUrl,
    required super.thematique,
    required super.label,
    required super.badgeLabel,
    required super.badgeColor,
    required super.badgeTextColor,
  });

  @override
  List<Object?> get props => [...super.props];
}

class ConcertationViewModel extends ConsultationViewModel {
  final String externalLink;

  ConcertationViewModel({
    required super.id,
    required super.slug,
    required super.title,
    required super.coverUrl,
    required super.thematique,
    required super.label,
    required super.badgeLabel,
    required super.badgeColor,
    required super.badgeTextColor,
    required this.externalLink,
  });

  @override
  List<Object?> get props => [...super.props, externalLink];
}
