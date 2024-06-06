import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:equatable/equatable.dart';

class ConsultationPaginatedViewModel extends Equatable {
  final String id;
  final String title;
  final String coverUrl;
  final ThematiqueViewModel thematique;
  final String? label;
  final String? externalLink;

  ConsultationPaginatedViewModel({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.thematique,
    required this.label,
    this.externalLink,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        coverUrl,
        thematique,
        label,
        externalLink,
      ];
}
