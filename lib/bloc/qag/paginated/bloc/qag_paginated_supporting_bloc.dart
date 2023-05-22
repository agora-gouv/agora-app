import 'package:agora/bloc/qag/paginated/bloc/qag_paginated_bloc.dart';
import 'package:agora/domain/qag/qag_paginated_filter.dart';
import 'package:agora/infrastructure/qag/qag_repository.dart';

class QagPaginatedSupportingBloc extends QagPaginatedBloc {
  QagPaginatedSupportingBloc({required QagRepository qagRepository})
      : super(qagRepository: qagRepository, qagPaginatedFilter: QagPaginatedFilter.supporting);
}
