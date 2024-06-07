import 'package:agora/bloc/qag/response/qag_response_a_venir_view_model.dart';
import 'package:agora/common/extension/thematique_extension.dart';
import 'package:agora/domain/qag/qag_response.dart';

class QagResponsePresenter {
  static List<QagResponseAVenirViewModel> presentQagResponse({
    required List<QagResponseIncoming> incomingQagResponses,
    required List<QagResponse> qagResponses,
  }) {
    return incomingQagResponses.map((response) {
      final QagResponseIncoming incomingQagResponse = response;
      return QagResponseAVenirViewModel(
        qagId: incomingQagResponse.qagId,
        thematique: incomingQagResponse.thematique.toThematiqueViewModel(),
        title: incomingQagResponse.title,
        supportCount: incomingQagResponse.supportCount,
        isSupported: incomingQagResponse.isSupported,
      );
    }).toList();
  }
}
