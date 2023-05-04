import 'package:agora/bloc/consultation/consultation_view_model.dart';
import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/common/extension/thematique_extension.dart';
import 'package:agora/domain/consultation/consultation.dart';

class ConsultationPresenter {
  static List<ConsultationOngoingViewModel> presentOngoingConsultations(
    List<ConsultationOngoing> ongoingConsultations,
  ) {
    return ongoingConsultations.map((consultation) {
      return ConsultationOngoingViewModel(
        id: consultation.id,
        title: consultation.title,
        coverUrl: consultation.coverUrl,
        thematique: consultation.thematique.toThematiqueViewModel(),
        endDate: consultation.endDate.formatToDayMonth(),
        hasAnswered: consultation.hasAnswered,
      );
    }).toList();
  }

  static List<ConsultationFinishedViewModel> presentFinishedConsultations(
    List<ConsultationFinished> finishedConsultations,
  ) {
    return finishedConsultations.map((consultation) {
      return ConsultationFinishedViewModel(
        id: consultation.id,
        title: consultation.title,
        coverUrl: consultation.coverUrl,
        thematique: consultation.thematique.toThematiqueViewModel(),
        step: consultation.step,
      );
    }).toList();
  }
}
