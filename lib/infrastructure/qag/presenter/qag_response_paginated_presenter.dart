import 'package:agora/bloc/qag/response_paginated/qag_response_paginated_view_model.dart';
import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/extension/thematique_extension.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/domain/qag/qag_response_paginated.dart';

class QagResponsePaginatedPresenter {
  static List<QagResponsePaginatedViewModel> presentQagResponsePaginated({
    required List<QagResponsePaginated> paginatedQagsResponse,
  }) {
    return paginatedQagsResponse
        .map(
          (qagResponse) => QagResponsePaginatedViewModel(
            qagId: qagResponse.qagId,
            thematique: qagResponse.thematique.toThematiqueViewModel(),
            title: qagResponse.title,
            author: qagResponse.author,
            authorPortraitUrl: qagResponse.authorPortraitUrl,
            responseDate: QagStrings.answeredAt.format(qagResponse.responseDate.formatToDayLongMonth()),
          ),
        )
        .toList();
  }
}
