import 'package:agora/qag/domain/qag_paginated_filter.dart';

extension QagPaginatedFilterExtension on QagPaginatedFilter {
  String toFilterString() {
    switch (this) {
      case QagPaginatedFilter.popular:
        return "popular";
      case QagPaginatedFilter.latest:
        return "latest";
      case QagPaginatedFilter.supporting:
        return "supporting";
    }
  }
}
