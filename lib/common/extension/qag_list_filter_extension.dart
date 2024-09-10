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

  String toFilterLabel() {
    switch (this) {
      case QagListFilter.trending:
        return "Tendances";
      case QagListFilter.top:
        return "Le top";
      case QagListFilter.latest:
        return "Récentes";
      case QagListFilter.supporting:
        return "Suivies";
    }
  }
}
