import 'package:equatable/equatable.dart';

class FetchQagsResponsePaginatedEvent extends Equatable {
  final int pageNumber;

  FetchQagsResponsePaginatedEvent({required this.pageNumber});

  @override
  List<Object> get props => [pageNumber];
}
