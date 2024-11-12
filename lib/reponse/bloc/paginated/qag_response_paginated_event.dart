import 'package:equatable/equatable.dart';

class FetchQagsResponsePaginatedEvent extends Equatable {
  final int pageNumber;
  final bool forceRefresh;

  FetchQagsResponsePaginatedEvent({required this.pageNumber, this.forceRefresh = false});

  @override
  List<Object> get props => [pageNumber, forceRefresh];
}
