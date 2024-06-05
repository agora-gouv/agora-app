import 'package:agora/domain/thematique/thematique.dart';
import 'package:equatable/equatable.dart';

class ConsultationPaginated extends Equatable {
  final String id;
  final String title;
  final String coverUrl;
  final Thematique thematique;
  final String? label;
  final DateTime? updateDate;

  ConsultationPaginated({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.thematique,
    required this.label,
    this.updateDate,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        coverUrl,
        thematique,
        label,
        updateDate,
      ];
}

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
