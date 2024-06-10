import 'package:agora/bloc/qag/response/qag_response_a_venir_view_model.dart';
import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/common/extension/thematique_extension.dart';
import 'package:agora/domain/qag/qag_response.dart';

class QagResponsePresenter {
  static List<QagResponseAVenirViewModel> presentQagResponse({
    required List<QagResponseIncoming> incomingQagResponses,
    required List<QagResponse> qagResponses,
  }) {
    return incomingQagResponses.map((response) {
      final QagResponseIncoming incomingQagResponse = response;

      final isMemeMois = incomingQagResponse.dateLundiPrecedent.month == incomingQagResponse.dateLundiSuivant.month;
      final dateLundiSuivantFormatee = incomingQagResponse.dateLundiSuivant.formatToDayMonth();
      final dateLundiPrecedentFormatee = incomingQagResponse.dateLundiPrecedent.formatToDayMonth();

      final semaineGagnanteLabel = isMemeMois
          ? 'semaine du ${incomingQagResponse.dateLundiPrecedent.day} au $dateLundiSuivantFormatee'
          : 'semaine du $dateLundiPrecedentFormatee au $dateLundiSuivantFormatee';

      return QagResponseAVenirViewModel(
        qagId: incomingQagResponse.qagId,
        thematique: incomingQagResponse.thematique.toThematiqueViewModel(),
        title: incomingQagResponse.title,
        supportCount: incomingQagResponse.supportCount,
        isSupported: incomingQagResponse.isSupported,
        semaineGagnanteLabel: semaineGagnanteLabel,
      );
    }).toList();
  }
}
