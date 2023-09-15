import 'package:equatable/equatable.dart';

abstract class QagsPaginatedEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchQagsPaginatedEvent extends QagsPaginatedEvent {
  final String? thematiqueId;
  final String? keywords;
  final int pageNumber;

  FetchQagsPaginatedEvent({required this.thematiqueId, required this.keywords, required this.pageNumber});

  @override
  List<Object?> get props => [thematiqueId, keywords, pageNumber];
}

class QagPaginatedDisplayLoaderEvent extends QagsPaginatedEvent {}

class UpdateQagsPaginatedEvent extends QagsPaginatedEvent {
  final String qagId;
  final int supportCount;
  final bool isSupported;
  final bool isAuthor;

  UpdateQagsPaginatedEvent({
    required this.qagId,
    required this.supportCount,
    required this.isSupported,
    required this.isAuthor,
  });

  @override
  List<Object> get props => [
        qagId,
        supportCount,
        isSupported,
        isAuthor,
      ];
}
