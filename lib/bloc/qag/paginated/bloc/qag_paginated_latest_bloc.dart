import 'package:agora/bloc/qag/paginated/bloc/qag_paginated_bloc.dart';
import 'package:agora/domain/qag/qag_paginated_filter.dart';
import 'package:agora/infrastructure/qag/qag_repository.dart';

class QagPaginatedLatestBloc extends QagPaginatedBloc {
  QagPaginatedLatestBloc({required QagRepository qagRepository})
      : super(qagRepository: qagRepository, qagPaginatedFilter: QagPaginatedFilter.latest);
}
