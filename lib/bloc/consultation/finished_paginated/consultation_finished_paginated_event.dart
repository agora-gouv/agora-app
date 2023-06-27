import 'package:equatable/equatable.dart';

class FetchConsultationFinishedPaginatedEvent extends Equatable {
  final int pageNumber;

  FetchConsultationFinishedPaginatedEvent({required this.pageNumber});

  @override
  List<Object> get props => [pageNumber];
}
