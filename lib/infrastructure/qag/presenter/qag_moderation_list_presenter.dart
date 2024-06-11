import 'package:agora/bloc/qag/moderation/list/qag_moderation_list_view_model.dart';
import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/common/extension/thematique_extension.dart';
import 'package:agora/domain/qag/moderation/qag_moderation_list.dart';

class QagModerationListPresenter {
  static QagModerationListViewModel present(QagModerationList qagModerationList) {
    return QagModerationListViewModel(
      totalNumber: qagModerationList.totalNumber,
      qagsToModerationViewModels: qagModerationList.qagsToModeration.map((qagToModeration) {
        return QagModerationViewModel(
          id: qagToModeration.id,
          thematique: qagToModeration.thematique.toThematiqueViewModel(),
          title: qagToModeration.title,
          description: qagToModeration.description,
          date: qagToModeration.date.formatToDayLongMonth(),
          username: qagToModeration.username,
          supportCount: qagToModeration.supportCount,
          isSupported: qagToModeration.isSupported,
        );
      }).toList(),
    );
  }
}
