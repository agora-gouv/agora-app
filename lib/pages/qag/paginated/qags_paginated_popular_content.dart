import 'package:agora/bloc/qag/paginated/bloc/qag_paginated_popular_bloc.dart';
import 'package:agora/bloc/qag/paginated/qag_paginated_event.dart';
import 'package:agora/bloc/qag/paginated/qag_paginated_state.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/pages/qag/details/qag_details_page.dart';
import 'package:agora/pages/qag/paginated/qags_paginated_content_builder.dart';
import 'package:agora/pages/qag/paginated/qags_paginated_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagsPaginatedPopularContent extends StatelessWidget {
  final String? thematiqueId;
  final Function(List<QagDetailsBackResult>) onQagDetailsBackResults;

  const QagsPaginatedPopularContent({
    super.key,
    required this.thematiqueId,
    required this.onQagDetailsBackResults,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QagPaginatedPopularBloc, QagPaginatedState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: AgoraSpacings.horizontalPadding,
              right: AgoraSpacings.horizontalPadding,
              top: AgoraSpacings.base,
            ),
            child: Column(
              children: QagsPaginatedContentBuilder.buildWidgets(
                context: context,
                paginatedTab: QagPaginatedTab.popular,
                qagPaginatedState: state,
                onDisplayMoreClick: () {
                  context.read<QagPaginatedPopularBloc>().add(
                        FetchQagsPaginatedEvent(
                          thematiqueId: thematiqueId,
                          pageNumber: state.currentPageNumber + 1,
                        ),
                      );
                },
                onRetryClick: () {
                  context.read<QagPaginatedPopularBloc>().add(
                        FetchQagsPaginatedEvent(
                          thematiqueId: thematiqueId,
                          pageNumber: state.currentPageNumber,
                        ),
                      );
                },
                onQagDetailsBackResults: (qagDetailsBackResults) => onQagDetailsBackResults(qagDetailsBackResults),
              ),
            ),
          ),
        );
      },
    );
  }
}
