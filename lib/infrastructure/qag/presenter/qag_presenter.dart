import 'package:agora/bloc/qag/qag_view_model.dart';
import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/common/extension/thematique_extension.dart';
import 'package:agora/domain/qag/qag.dart';

class QagPresenter {
  static List<QagViewModel> presentQag(List<Qag> qags) {
    return qags
        .map(
          (qag) => QagViewModel(
            id: qag.id,
            thematique: qag.thematique.toThematiqueViewModel(),
            title: qag.title,
            username: qag.username,
            date: qag.date.formatToDayMonth(),
            supportCount: qag.supportCount,
            isSupported: qag.isSupported,
          ),
        )
        .toList();
  }
}
