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
  final int supportCount;
  final bool isSupported;

  UpdateQagsPaginatedEvent({
    required this.qagId,
    required this.supportCount,
    required this.isSupported,
  });

  @override
  List<Object> get props => [
        qagId,
        supportCount,
        isSupported,
      ];
}
