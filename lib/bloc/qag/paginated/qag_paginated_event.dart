import 'package:equatable/equatable.dart';

class FetchQagsPaginatedEvent extends Equatable {
  final String? thematiqueId;
  final int pageNumber;

  FetchQagsPaginatedEvent({required this.thematiqueId, required this.pageNumber});

  @override
  List<Object?> get props => [thematiqueId, pageNumber];
}
