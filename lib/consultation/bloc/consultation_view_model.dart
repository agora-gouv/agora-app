import 'package:agora/thematique/bloc/thematique_view_model.dart';
import 'package:equatable/equatable.dart';

class ConsultationViewModel extends Equatable {
  final String id;
  final String title;
  final String coverUrl;
  final ThematiqueViewModel thematique;
  final String? label;

  ConsultationViewModel({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.thematique,
    required this.label,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        coverUrl,
        thematique,
        label,
      ];
}

class ConsultationOngoingViewModel extends ConsultationViewModel {
  final String endDate;

  ConsultationOngoingViewModel({
    required super.id,
    required super.title,
    required super.coverUrl,
    required super.thematique,
    required super.label,
    required this.endDate,
  });

  @override
  List<Object?> get props => [...super.props, endDate];
}

class ConsultationFinishedViewModel extends ConsultationViewModel {
  ConsultationFinishedViewModel({
    required super.id,
    required super.title,
    required super.coverUrl,
    required super.thematique,
    required super.label,
  });

  @override
  List<Object?> get props => [...super.props];
}

class ConsultationAnsweredViewModel extends ConsultationViewModel {
  ConsultationAnsweredViewModel({
    required super.id,
    required super.title,
    required super.coverUrl,
    required super.thematique,
    required super.label,
  });

  @override
  List<Object?> get props => [...super.props];
}

class ConcertationViewModel extends ConsultationViewModel {
  final String externalLink;

  ConcertationViewModel({
    required super.id,
    required super.title,
    required super.coverUrl,
    required super.thematique,
    required super.label,
    required this.externalLink,
  });

  @override
  List<Object?> get props => [...super.props, externalLink];
}
