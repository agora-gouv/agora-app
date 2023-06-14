import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:equatable/equatable.dart';

class QagDetailsViewModel extends Equatable {
  final String id;
  final ThematiqueViewModel thematique;
  final String title;
  final String description;
  final String username;
  final String date;
  final bool canShare;
  final QagDetailsSupportViewModel? support;
  final QagDetailsResponseViewModel? response;

  QagDetailsViewModel({
    required this.id,
    required this.thematique,
    required this.title,
    required this.description,
    required this.username,
    required this.date,
    required this.canShare,
    required this.support,
    required this.response,
  });

  @override
  List<Object?> get props => [
        id,
        thematique,
        title,
        description,
        username,
        date,
        canShare,
        support,
        response,
      ];
}

class QagDetailsSupportViewModel extends Equatable {
  final int count;
  final bool isSupported;

  QagDetailsSupportViewModel({required this.count, required this.isSupported});

  @override
  List<Object> get props => [
        count,
        isSupported,
      ];
}

class QagDetailsResponseViewModel extends Equatable {
  final String author;
  final String authorDescription;
  final String responseDate;
  final String videoUrl;
  final String transcription;
  final bool feedbackStatus;

  QagDetailsResponseViewModel({
    required this.author,
    required this.authorDescription,
    required this.responseDate,
    required this.videoUrl,
    required this.transcription,
    required this.feedbackStatus,
  });

  @override
  List<Object> get props => [
        author,
        authorDescription,
        responseDate,
        videoUrl,
        transcription,
        feedbackStatus,
      ];
}
