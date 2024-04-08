import 'package:agora/domain/thematique/thematique.dart';
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

  QagResponseIncoming({
    required super.qagId,
    required super.thematique,
    required super.title,
    required this.supportCount,
    required this.isSupported,
    required super.order,
  });

  @override
  List<Object> get props => [
        qagId,
        thematique,
        title,
        supportCount,
        isSupported,
        order,
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
