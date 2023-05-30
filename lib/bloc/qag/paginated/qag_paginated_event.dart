import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:equatable/equatable.dart';

class QagsPaginatedEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchQagsPaginatedEvent extends QagsPaginatedEvent {
  final String? thematiqueId;
  final int pageNumber;

  FetchQagsPaginatedEvent({required this.thematiqueId, required this.pageNumber});

  @override
  List<Object?> get props => [thematiqueId, pageNumber];
}

class UpdateQagsPaginatedEvent extends QagsPaginatedEvent {
  final String qagId;
  final ThematiqueViewModel thematique;
  final String title;
  final String username;
  final String date;
  final int supportCount;
  final bool isSupported;

  UpdateQagsPaginatedEvent({
    required this.qagId,
    required this.thematique,
    required this.title,
    required this.username,
    required this.date,
    required this.supportCount,
    required this.isSupported,
  });

  @override
  List<Object> get props => [
        qagId,
        thematique,
        title,
        username,
        date,
        supportCount,
        isSupported,
      ];
}
