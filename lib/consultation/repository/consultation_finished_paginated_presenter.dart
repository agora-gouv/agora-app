import 'package:agora/common/extension/thematique_extension.dart';
import 'package:agora/consultation/domain/consultation.dart';
import 'package:agora/consultation/finished_paginated/bloc/consultation_finished_paginated_view_model.dart';
import 'package:agora/territorialisation/region.dart';
import 'package:agora/territorialisation/territoire_helper.dart';

class ConsultationFinishedPaginatedPresenter {
  static List<ConsultationPaginatedViewModel> presentPaginatedConsultations(
    List<Consultation> finishedConsultations,
    List<Consultation> concertations,
    List<Region> referentiel,
  ) {
    final allConsultationPaginated = [...finishedConsultations, ...concertations];
    allConsultationPaginated.sort((a, b) {
      if (a.updateDate == null || b.updateDate == null) return 0;
      return b.updateDate!.compareTo(a.updateDate!);
    });
    return allConsultationPaginated.map(
      (consultation) {
        final territoire = getTerritoireFromReferentiel(referentiel, consultation.territoire);
        return ConsultationPaginatedViewModel(
          id: consultation.id,
          title: consultation.title,
          coverUrl: consultation.coverUrl,
          thematique: consultation.thematique.toThematiqueViewModel(),
          label: consultation.label,
          externalLink: consultation is Concertation ? consultation.externalLink : null,
          badgeLabel: territoire.label.toUpperCase(),
          badgeColor: getTerritoireBadgeColor(territoire.type),
          badgeTextColor: getTerritoireBadgeTexteColor(territoire.type),
        );
      },
    ).toList();
  }
}
