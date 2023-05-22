import 'package:agora/bloc/qag/paginated/qag_paginated_view_model.dart';
import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/common/extension/thematique_extension.dart';
import 'package:agora/domain/qag/qag_paginated.dart';

class QagPaginatedPresenter {
  static List<QagPaginatedViewModel> presentQagPaginated(List<QagPaginated> qags) {
    return qags
        .map(
          (qag) => QagPaginatedViewModel(
            id: qag.id,
            thematique: qag.thematique.toThematiqueViewModel(),
            title: qag.title,
            username: qag.username,
            date: qag.date.formatToDayMonth(),
            supportCount: qag.supportCount,
            isSupported: qag.isSupported,
          ),
        )
        .toList();
  }
}
