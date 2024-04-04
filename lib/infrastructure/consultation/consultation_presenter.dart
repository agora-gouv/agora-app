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
        highlightLabel: consultation.highlightLabel,
      );
    }).toList();
  }

  static List<ConsultationFinishedViewModel> presentFinishedConsultations({
    required List<ConsultationOngoing> ongoingConsultations,
    required List<ConsultationFinished> finishedConsultations,
  }) {
    if (finishedConsultations.isNotEmpty) {
      return finishedConsultations.map((consultation) {
        return ConsultationFinishedViewModel(
          id: consultation.id,
          title: consultation.title,
          coverUrl: consultation.coverUrl,
          thematique: consultation.thematique.toThematiqueViewModel(),
          label: consultation.label,
        );
      }).toList();
    } else {
      return ongoingConsultations.map((consultation) {
        return ConsultationFinishedViewModel(
          id: consultation.id,
          title: consultation.title,
          coverUrl: consultation.coverUrl,
          thematique: consultation.thematique.toThematiqueViewModel(),
          label: null,
        );
      }).toList();
    }
  }

  static List<ConsultationAnsweredViewModel> presentAnsweredConsultations(
    List<ConsultationAnswered> answeredConsultations,
  ) {
    return answeredConsultations.map((consultation) {
      return ConsultationAnsweredViewModel(
        id: consultation.id,
        title: consultation.title,
        coverUrl: consultation.coverUrl,
        thematique: consultation.thematique.toThematiqueViewModel(),
        label: consultation.label,
      );
    }).toList();
  }
}
