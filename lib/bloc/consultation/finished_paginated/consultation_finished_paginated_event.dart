import 'package:agora/pages/consultation/finished_paginated/consultation_finished_paginated_page.dart';
import 'package:equatable/equatable.dart';

class FetchConsultationPaginatedEvent extends Equatable {
  final int pageNumber;
  final ConsultationPaginatedPageType type;

  FetchConsultationPaginatedEvent({required this.pageNumber, required this.type});

  @override
  List<Object> get props => [pageNumber, type];
}
