import 'package:equatable/equatable.dart';

class QagDetails extends Equatable {
  final String id;
  final String thematiqueId;
  final String title;
  final String description;
  final DateTime date;
  final String username;
  final QagDetailsSupport? support;

  QagDetails({
    required this.id,
    required this.thematiqueId,
    required this.title,
    required this.description,
    required this.date,
    required this.username,
    required this.support,
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
