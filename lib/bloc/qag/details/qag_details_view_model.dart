import 'package:equatable/equatable.dart';

class QagDetailsViewModel extends Equatable {
  final String id;
  final String thematiqueId;
  final String title;
  final String description;
  final String username;
  final String date;
  final QagDetailsSupportViewModel? support;
  final QagDetailsResponseViewModel? response;

  QagDetailsViewModel({
    required this.id,
    required this.thematiqueId,
    required this.title,
    required this.description,
    required this.username,
    required this.date,
    required this.support,
    required this.response,
  });

  @override
  List<Object?> get props => [
        id,
        thematiqueId,
        title,
        description,
        username,
        date,
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
  final bool? feedbackStatus;

  QagDetailsResponseViewModel({
    required this.author,
    required this.authorDescription,
    required this.responseDate,
    required this.videoUrl,
    required this.transcription,
    required this.feedbackStatus,
  });

  @override
  List<Object?> get props => [
        author,
        authorDescription,
        responseDate,
        videoUrl,
        transcription,
        feedbackStatus,
      ];
}
