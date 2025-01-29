import 'package:agora/consultation/finished_paginated/pages/consultation_finished_paginated_page.dart';
import 'package:agora/referentiel/territoire.dart';
import 'package:equatable/equatable.dart';

class FetchConsultationPaginatedEvent extends Equatable {
  final int pageNumber;
  final ConsultationPaginatedPageType type;
  final Territoire? filtreTerritoire;

  FetchConsultationPaginatedEvent({required this.pageNumber, required this.type, this.filtreTerritoire});

  @override
  List<Object> get props => [pageNumber, type];
}
