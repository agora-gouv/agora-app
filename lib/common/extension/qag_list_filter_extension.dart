import 'package:agora/qag/domain/qas_list_filter.dart';

extension QagPaginatedFilterExtension on QagListFilter {
  String toFilterString() {
    switch (this) {
      case QagListFilter.trending:
        return "trending";
      case QagListFilter.top:
        return "top";
      case QagListFilter.latest:
        return "latest";
      case QagListFilter.supporting:
        return "supporting";
    }
  }
}
