import 'package:agora/consultation/finished_paginated/bloc/consultation_finished_paginated_view_model.dart';
import 'package:agora/common/extension/thematique_extension.dart';
import 'package:agora/consultation/domain/consultation.dart';

class ConsultationFinishedPaginatedPresenter {
  static List<ConsultationPaginatedViewModel> presentPaginatedConsultations(
    List<Consultation> finishedConsultations,
    List<Consultation> concertations,
  ) {
    final allConsultationPaginated = [...finishedConsultations, ...concertations];
    allConsultationPaginated.sort((a, b) {
      if (a.updateDate == null || b.updateDate == null) return 0;
      return b.updateDate!.compareTo(a.updateDate!);
    });
    return allConsultationPaginated.map(
      (consultation) {
        return ConsultationPaginatedViewModel(
          id: consultation.id,
          title: consultation.title,
          coverUrl: consultation.coverUrl,
          thematique: consultation.thematique.toThematiqueViewModel(),
          label: consultation.label,
          externalLink: consultation is Concertation ? consultation.externalLink : null,
        );
      },
    ).toList();
  }
}
