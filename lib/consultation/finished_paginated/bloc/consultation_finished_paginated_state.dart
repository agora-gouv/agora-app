import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/consultation/finished_paginated/bloc/consultation_finished_paginated_view_model.dart';
import 'package:agora/territorialisation/territoire.dart';
import 'package:equatable/equatable.dart';
import 'package:optional/optional.dart';

class ConsultationPaginatedState extends Equatable {
  final ConsultationsListState consultationsListState;
  final TerritoireState territoireState;
  final int currentPageNumber;
  final int maxPage;
  final Territoire? filtreTerritoire;

  ConsultationPaginatedState({
    required this.consultationsListState,
    required this.territoireState,
    required this.currentPageNumber,
    required this.maxPage,
    this.filtreTerritoire,
  });

  ConsultationPaginatedState.init({
    this.consultationsListState =
        const ConsultationsListState(status: AllPurposeStatus.notLoaded, consultationViewModels: []),
    this.territoireState = const TerritoireState(status: AllPurposeStatus.notLoaded, territoires: []),
    this.currentPageNumber = -1,
    this.maxPage = -1,
    this.filtreTerritoire,
  });

  ConsultationPaginatedState clone({
    ConsultationsListState? consultationsListState,
    TerritoireState? territoireState,
    int? currentPageNumber,
    int? maxPage,
    Optional<Territoire>? filtreTerritoireOptional,
  }) =>
      ConsultationPaginatedState(
        consultationsListState: consultationsListState ?? this.consultationsListState,
        territoireState: territoireState ?? this.territoireState,
        currentPageNumber: currentPageNumber ?? this.currentPageNumber,
        maxPage: maxPage ?? this.maxPage,
        filtreTerritoire:
            filtreTerritoireOptional != null ? filtreTerritoireOptional.orElseNullable(null) : filtreTerritoire,
      );

  @override
  List<Object> get props => [consultationsListState, territoireState, currentPageNumber, maxPage];
}

class ConsultationsListState extends Equatable {
  final AllPurposeStatus status;
  final List<ConsultationPaginatedViewModel> consultationViewModels;

  const ConsultationsListState({
    required this.status,
    required this.consultationViewModels,
  });

  @override
  List<Object?> get props => [status, consultationViewModels];
}

class TerritoireState extends Equatable {
  final AllPurposeStatus status;
  final List<Territoire> territoires;

  const TerritoireState({
    required this.status,
    required this.territoires,
  });

  TerritoireState clone({
    List<Territoire>? territoires,
    AllPurposeStatus? status,
  }) {
    return TerritoireState(
      territoires: territoires ?? this.territoires,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [status, territoires];
}
