import 'package:agora/bloc/qag/similar/qag_similar_view_model.dart';
import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/common/extension/thematique_extension.dart';
import 'package:agora/domain/qag/qag_similar.dart';

class QagSimilarPresenter {
  static List<QagSimilarViewModel> present(List<QagSimilar> similarQags) {
    return similarQags.map((similarQag) {
      return QagSimilarViewModel(
        id: similarQag.id,
        thematique: similarQag.thematique.toThematiqueViewModel(),
        title: similarQag.title,
        description: similarQag.description,
        date: similarQag.date.formatToDayMonth(),
        username: similarQag.username,
        supportCount: similarQag.supportCount,
        isSupported: similarQag.isSupported,
      );
    }).toList();
  }
}
