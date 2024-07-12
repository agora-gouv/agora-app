import 'package:agora/qag/repository/presenter/qag_display_model.dart';
import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/common/extension/thematique_extension.dart';
import 'package:agora/qag/domain/qag.dart';

class QagPresenter {
  static List<QagDisplayModel> presentQag(List<Qag> qags) {
    return qags
        .map(
          (qag) => QagDisplayModel(
            id: qag.id,
            thematique: qag.thematique.toThematiqueViewModel(),
            title: qag.title,
            username: qag.username,
            date: qag.date.formatToDayLongMonth(),
            supportCount: qag.supportCount,
            isSupported: qag.isSupported,
            isAuthor: qag.isAuthor,
          ),
        )
        .toList();
  }
}
