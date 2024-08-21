import 'package:agora/thematique/domain/thematique.dart';
import 'package:equatable/equatable.dart';

sealed class QagResponsePreview extends Equatable {
  final String qagId;
  final Thematique thematique;
  final String title;
  final int order;

  QagResponsePreview({required this.qagId, required this.thematique, required this.title, required this.order});
}

class QagResponseIncoming extends QagResponsePreview {
  final int supportCount;
  final bool isSupported;
  final DateTime dateLundiPrecedent;
  final DateTime dateLundiSuivant;

  QagResponseIncoming({
    required super.qagId,
    required super.thematique,
    required super.title,
    required super.order,
    required this.supportCount,
    required this.isSupported,
    required this.dateLundiPrecedent,
    required this.dateLundiSuivant,
  });

  @override
  List<Object> get props => [
        qagId,
        thematique,
        title,
        supportCount,
        isSupported,
        order,
        dateLundiPrecedent,
        dateLundiSuivant,
      ];
}

class QagResponse extends QagResponsePreview {
  final String author;
  final String authorPortraitUrl;
  final DateTime responseDate;

  QagResponse({
    required super.qagId,
    required super.thematique,
    required super.title,
    required this.author,
    required this.authorPortraitUrl,
    required this.responseDate,
    required super.order,
  });

  @override
  List<Object> get props => [
        qagId,
        thematique,
        title,
        author,
        authorPortraitUrl,
        responseDate,
        order,
      ];
}
