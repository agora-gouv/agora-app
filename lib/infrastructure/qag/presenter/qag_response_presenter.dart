import 'package:agora/bloc/qag/response/qag_response_view_model.dart';
import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/extension/thematique_extension.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/domain/qag/qag_response.dart';

class QagResponsePresenter {
  static List<QagResponseTypeViewModel> presentQagResponse({
    required List<QagResponseIncoming> incomingQagResponses,
    required List<QagResponse> qagResponses,
  }) {
    final List<QagResponsePreview> sortedResponses = [];
    sortedResponses.addAll(incomingQagResponses);
    sortedResponses.addAll(qagResponses);
    sortedResponses.sort((response1, response2) => response1.order.compareTo(response2.order));

    return sortedResponses
        .map(
          (response) => switch (response) {
            final QagResponseIncoming incomingQagResponse => QagResponseIncomingViewModel(
                qagId: incomingQagResponse.qagId,
                thematique: incomingQagResponse.thematique.toThematiqueViewModel(),
                title: incomingQagResponse.title,
                supportCount: incomingQagResponse.supportCount,
                isSupported: incomingQagResponse.isSupported,
              ),
            final QagResponse qagResponse => QagResponseViewModel(
                qagId: qagResponse.qagId,
                thematique: qagResponse.thematique.toThematiqueViewModel(),
                title: qagResponse.title,
                author: qagResponse.author,
                authorPortraitUrl: qagResponse.authorPortraitUrl,
                responseDate: QagStrings.answeredAt.format(qagResponse.responseDate.formatToDayMonth()),
              ),
          },
        )
        .toList();
  }
}
