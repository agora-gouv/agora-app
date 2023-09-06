import 'package:agora/bloc/qag/qag_view_model.dart';
import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/extension/thematique_extension.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/domain/qag/qag_response.dart';
import 'package:agora/domain/qag/qag_response_incoming.dart';

class QagResponsePresenter {
  static List<QagResponseTypeViewModel> presentQagResponse({
    required List<QagResponseIncoming> incomingQagResponses,
    required List<QagResponse> qagResponses,
  }) {
    final List<QagResponseTypeViewModel> viewModels = [];
    for (final incomingQagResponse in incomingQagResponses) {
      viewModels.add(
        QagResponseIncomingViewModel(
          qagId: incomingQagResponse.qagId,
          thematique: incomingQagResponse.thematique.toThematiqueViewModel(),
          title: incomingQagResponse.title,
          supportCount: incomingQagResponse.supportCount,
          isSupported: incomingQagResponse.isSupported,
        ),
      );
    }
    for (final qagResponse in qagResponses) {
      viewModels.add(
        QagResponseViewModel(
          qagId: qagResponse.qagId,
          thematique: qagResponse.thematique.toThematiqueViewModel(),
          title: qagResponse.title,
          author: qagResponse.author,
          authorPortraitUrl: qagResponse.authorPortraitUrl,
          responseDate: QagStrings.answeredAt.format(qagResponse.responseDate.formatToDayMonth()),
        ),
      );
    }
    return viewModels;
  }
}
