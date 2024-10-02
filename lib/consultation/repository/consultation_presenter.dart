import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/common/extension/thematique_extension.dart';
import 'package:agora/consultation/bloc/consultation_view_model.dart';
import 'package:agora/consultation/domain/consultation.dart';
import 'package:agora/territorialisation/region.dart';
import 'package:agora/territorialisation/territoire_helper.dart';

class ConsultationPresenter {
  static List<ConsultationOngoingViewModel> presentOngoingConsultations(
    List<ConsultationOngoing> ongoingConsultations,
    List<Region> referentiel,
  ) {
    return ongoingConsultations.map((consultation) {
      final territoire = getTerritoireFromReferentiel(referentiel, consultation.territoire);
      return ConsultationOngoingViewModel(
        id: consultation.id,
        slug: consultation.slug,
        title: consultation.title,
        coverUrl: consultation.coverUrl,
        thematique: consultation.thematique.toThematiqueViewModel(),
        endDate: consultation.endDate!.formatToDayLongMonth(),
        label: consultation.label,
        badgeLabel: territoire.label.toUpperCase(),
        badgeColor: getTerritoireBadgeColor(territoire.type),
        badgeTextColor: getTerritoireBadgeTexteColor(territoire.type),
      );
    }).toList();
  }

  static List<ConsultationViewModel> presentFinishedConsultations({
    required List<ConsultationOngoing> ongoingConsultations,
    required List<Consultation> finishedConsultations,
    required List<Consultation> concertations,
    required List<Region> referentiel,
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
        final territoire = getTerritoireFromReferentiel(referentiel, consultation.territoire);
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
              badgeLabel: territoire.label.toUpperCase(),
              badgeColor: getTerritoireBadgeColor(territoire.type),
              badgeTextColor: getTerritoireBadgeTexteColor(territoire.type),
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
              badgeLabel: territoire.label.toUpperCase(),
              badgeColor: getTerritoireBadgeColor(territoire.type),
              badgeTextColor: getTerritoireBadgeTexteColor(territoire.type),
            ),
          );
        }
      }
      return finishedViewModels;
    } else {
      return ongoingConsultations.map((consultation) {
        final territoire = getTerritoireFromReferentiel(referentiel, consultation.territoire);
        return ConsultationFinishedViewModel(
          id: consultation.id,
          slug: consultation.slug,
          title: consultation.title,
          coverUrl: consultation.coverUrl,
          thematique: consultation.thematique.toThematiqueViewModel(),
          label: null,
          badgeLabel: territoire.label.toUpperCase(),
          badgeColor: getTerritoireBadgeColor(territoire.type),
          badgeTextColor: getTerritoireBadgeTexteColor(territoire.type),
        );
      }).toList();
    }
  }

  static List<ConsultationAnsweredViewModel> presentAnsweredConsultations(
    List<ConsultationAnswered> answeredConsultations,
    List<Region> referentiel,
  ) {
    return answeredConsultations.map((consultation) {
      final territoire = getTerritoireFromReferentiel(referentiel, consultation.territoire);
      return ConsultationAnsweredViewModel(
        id: consultation.id,
        slug: consultation.slug,
        title: consultation.title,
        coverUrl: consultation.coverUrl,
        thematique: consultation.thematique.toThematiqueViewModel(),
        label: consultation.label,
        badgeLabel: territoire.label.toUpperCase(),
        badgeColor: getTerritoireBadgeColor(territoire.type),
        badgeTextColor: getTerritoireBadgeTexteColor(territoire.type),
      );
    }).toList();
  }
}
