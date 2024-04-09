import 'package:agora/bloc/consultation/finished_paginated/consultation_finished_paginated_view_model.dart';
import 'package:agora/common/extension/thematique_extension.dart';
import 'package:agora/domain/consultation/consultation_finished_paginated.dart';

class ConsultationFinishedPaginatedPresenter {
  static List<ConsultationFinishedPaginatedViewModel> presentPaginatedConsultations(
    List<ConsultationFinishedPaginated> finishedConsultations,
  ) {
    return finishedConsultations.map((consultation) {
      return ConsultationFinishedPaginatedViewModel(
        id: consultation.id,
        title: consultation.title,
        coverUrl: consultation.coverUrl,
        thematique: consultation.thematique.toThematiqueViewModel(),
        label: consultation.label,
      );
    }).toList();
  }
}
