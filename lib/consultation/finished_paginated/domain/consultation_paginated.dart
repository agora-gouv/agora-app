import 'package:agora/thematique/domain/thematique.dart';
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
