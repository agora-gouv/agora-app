import 'package:agora/qag/pages/qags_page.dart';

enum QagListFilter { trending, top, latest, supporting }

QagListFilter toQagListFilter(QagTab qagTab) {
  switch (qagTab) {
    case QagTab.trending:
      return QagListFilter.trending;
    case QagTab.top:
      return QagListFilter.top;
    case QagTab.latest:
      return QagListFilter.latest;
    case QagTab.supporting:
      return QagListFilter.supporting;
    default:
      throw Exception('Unsupported QagListFilter value');
  }
}
