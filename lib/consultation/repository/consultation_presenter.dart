import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/common/extension/thematique_extension.dart';
import 'package:agora/consultation/bloc/consultation_view_model.dart';
import 'package:agora/consultation/domain/consultation.dart';

class ConsultationPresenter {
  static List<ConsultationOngoingViewModel> presentOngoingConsultations(
    List<ConsultationOngoing> ongoingConsultations,
  ) {
    return ongoingConsultations.map((consultation) {
      return ConsultationOngoingViewModel(
        id: consultation.id,
        slug: consultation.slug,
        title: consultation.title,
        coverUrl: consultation.coverUrl,
        thematique: consultation.thematique.toThematiqueViewModel(),
        endDate: consultation.endDate!.formatToDayLongMonth(),
        label: consultation.label,
      );
    }).toList();
  }

  static List<ConsultationViewModel> presentFinishedConsultations({
    required List<ConsultationOngoing> ongoingConsultations,
    required List<Consultation> finishedConsultations,
    required List<Consultation> concertations,
  }) {
    final allConsultations = [...finishedConsultations, ...concertations];
    allConsultations.sort((a, b) {
      if (a.updateDate == null || b.updateDate == null) return 0;
      return b.updateDate!.compareTo(a.updateDate!);
    });
    if (finishedConsultations.isNotEmpty) {
      final List<ConsultationViewModel> finishedViewModels = [];
      final limitedConsultations = allConsultations.take(8);
      for (var consultation in limitedConsultations) {
        if (consultation is Concertation) {
          finishedViewModels.add(
            ConcertationViewModel(
              id: consultation.id,
              slug: consultation.slug,
              title: consultation.title,
              coverUrl: consultation.coverUrl,
              thematique: consultation.thematique.toThematiqueViewModel(),
              label: consultation.label,
              externalLink: consultation.externalLink,
            ),
          );
        } else if (consultation is ConsultationFinished) {
          finishedViewModels.add(
            ConsultationFinishedViewModel(
              id: consultation.id,
              slug: consultation.slug,
              title: consultation.title,
              coverUrl: consultation.coverUrl,
              thematique: consultation.thematique.toThematiqueViewModel(),
              label: consultation.label,
            ),
          );
        }
      }
      return finishedViewModels;
    } else {
      return ongoingConsultations.map((consultation) {
        return ConsultationFinishedViewModel(
          id: consultation.id,
          slug: consultation.slug,
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
        slug: consultation.slug,
        title: consultation.title,
        coverUrl: consultation.coverUrl,
        thematique: consultation.thematique.toThematiqueViewModel(),
        label: consultation.label,
      );
    }).toList();
  }
}
