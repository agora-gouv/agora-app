import 'package:agora/consultation/finished_paginated/domain/consultation_paginated.dart';

class ConsultationFinishedPaginated extends ConsultationPaginated {
  ConsultationFinishedPaginated({
    required super.id,
    required super.title,
    required super.coverUrl,
    required super.thematique,
    super.updateDate,
    super.label,
  });

  @override
  List<Object?> get props => [...super.props];
}

class ConcertationPaginated extends ConsultationPaginated {
  final String externalLink;

  ConcertationPaginated({
    required super.id,
    required super.title,
    required super.coverUrl,
    required super.thematique,
    super.label,
    super.updateDate,
    required this.externalLink,
  });

  @override
  List<Object?> get props => [...super.props, externalLink];
}
