import 'package:agora/bloc/qag/qag_view_model.dart';
import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/extension/thematique_extension.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/domain/qag/qag_response.dart';

class QagPresenter {
  static List<QagResponseViewModel> present(List<QagResponse> qagResponses) {
    return qagResponses
        .map(
          (qagResponse) => QagResponseViewModel(
            qagId: qagResponse.qagId,
            thematique: qagResponse.thematique.toThematiqueViewModel(),
            title: qagResponse.title,
            author: qagResponse.author,
            authorPortraitUrl: qagResponse.authorPortraitUrl,
            responseDate: QagStrings.answeredAt.format(qagResponse.responseDate.formatToDayMonth()),
          ),
        )
        .toList();
  }
}
