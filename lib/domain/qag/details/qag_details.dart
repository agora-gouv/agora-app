import 'package:equatable/equatable.dart';

class QagDetails extends Equatable {
  final String id;
  final String thematiqueId;
  final String title;
  final String description;
  final DateTime date;
  final String username;
  final QagDetailsSupport? support;
  final QagDetailsResponse? response;

  QagDetails({
    required this.id,
    required this.thematiqueId,
    required this.title,
    required this.description,
    required this.date,
    required this.username,
    required this.support,
    required this.response,
  });

  @override
  List<Object?> get props => [
        id,
        thematiqueId,
        title,
        description,
        date,
        username,
        support,
        response,
      ];
}

class QagDetailsSupport extends Equatable {
  final int count;
  final bool isSupported;

  QagDetailsSupport({required this.count, required this.isSupported});

  @override
  List<Object?> get props => [
        count,
        isSupported,
      ];
}

class QagDetailsResponse extends Equatable {
  final String author;
  final String authorDescription;
  final DateTime responseDate;
  final String videoUrl;
  final String transcription;
  final bool? feedbackStatus;

  QagDetailsResponse({
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
