import 'package:agora/domain/qag/qas_list_filter.dart';

extension QagPaginatedFilterExtension on QagListFilter {
  String toFilterString() {
    switch (this) {
      case QagListFilter.popular:
        return "popular";
      case QagListFilter.latest:
        return "latest";
      case QagListFilter.supporting:
        return "supporting";
    }
  }
}
