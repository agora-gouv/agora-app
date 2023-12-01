import 'package:agora/domain/qag/qag.dart';
import 'package:agora/domain/qag/qag_support.dart';

extension QagListExtension on List<Qag> {
  List<Qag>? updateQagSupportOrNull(QagSupport qagSupport) {
    if (any((qag) => qag.id == qagSupport.qagId)) {
      return map((qag) {
        if (qag.id == qagSupport.qagId) {
          return Qag(
            id: qag.id,
            thematique: qag.thematique,
            title: qag.title,
            username: qag.username,
            date: qag.date,
            supportCount: qagSupport.supportCount,
            isSupported: qagSupport.isSupported,
            isAuthor: qag.isAuthor,
          );
        } else {
          return qag;
        }
      }).toList();
    } else {
      return null;
    }
  }
}
