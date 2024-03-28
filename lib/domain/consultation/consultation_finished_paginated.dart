import 'package:agora/domain/thematique/thematique.dart';
import 'package:equatable/equatable.dart';

class ConsultationFinishedPaginated extends Equatable {
  final String id;
  final String title;
  final String coverUrl;
  final Thematique thematique;
  final String? label;

  ConsultationFinishedPaginated({
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
