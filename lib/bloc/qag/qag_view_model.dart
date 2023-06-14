import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:equatable/equatable.dart';

abstract class QagResponseTypeViewModel extends Equatable {
  final String qagId;
  final ThematiqueViewModel thematique;
  final String title;

  QagResponseTypeViewModel({
    required this.qagId,
    required this.thematique,
    required this.title,
  });

  @override
  List<Object> get props => [
        qagId,
        thematique,
        title,
      ];
}

class QagResponseViewModel extends QagResponseTypeViewModel {
  final String author;
  final String authorPortraitUrl;
  final String responseDate;

  QagResponseViewModel({
    required super.qagId,
    required super.thematique,
    required super.title,
    required this.author,
    required this.authorPortraitUrl,
    required this.responseDate,
  });

  @override
  List<Object> get props => [
        qagId,
        thematique,
        title,
        author,
        authorPortraitUrl,
        responseDate,
      ];
}

class QagResponseIncomingViewModel extends QagResponseTypeViewModel {
  final int supportCount;
  final bool isSupported;

  QagResponseIncomingViewModel({
    required super.qagId,
    required super.thematique,
    required super.title,
    required this.supportCount,
    required this.isSupported,
  });

  @override
  List<Object> get props => [
        qagId,
        thematique,
        title,
        supportCount,
        isSupported,
      ];
}

class QagViewModel extends Equatable {
  final String id;
  final ThematiqueViewModel thematique;
  final String title;
  final String username;
  final String date;
  final int supportCount;
  final bool isSupported;

  QagViewModel({
    required this.id,
    required this.thematique,
    required this.title,
    required this.username,
    required this.date,
    required this.supportCount,
    required this.isSupported,
  });

  @override
  List<Object> get props => [
        id,
        thematique,
        title,
        username,
        date,
        supportCount,
        isSupported,
      ];
}
