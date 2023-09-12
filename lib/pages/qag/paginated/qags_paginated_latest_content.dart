import 'package:agora/bloc/qag/paginated/bloc/qag_paginated_latest_bloc.dart';
import 'package:agora/bloc/qag/paginated/qag_paginated_event.dart';
import 'package:agora/bloc/qag/paginated/qag_paginated_state.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/pages/qag/paginated/qags_paginated_content_builder.dart';
import 'package:agora/pages/qag/paginated/qags_paginated_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagsPaginatedLatestContent extends StatelessWidget {
  final String? thematiqueId;

  const QagsPaginatedLatestContent({
    super.key,
    required this.thematiqueId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QagPaginatedLatestBloc, QagPaginatedState>(
      builder: (context, state) {
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(top: AgoraSpacings.base),
            child: Column(
              children: QagsPaginatedContentBuilder.buildWidgets(
                context: context,
                paginatedTab: QagPaginatedTab.latest,
                qagPaginatedState: state,
                onDisplayMoreClick: () => context.read<QagPaginatedLatestBloc>().add(
                      FetchQagsPaginatedEvent(
                        thematiqueId: thematiqueId,
                        pageNumber: state.currentPageNumber + 1,
                      ),
                    ),
                onRetryClick: () => context.read<QagPaginatedLatestBloc>().add(
                      FetchQagsPaginatedEvent(
                        thematiqueId: thematiqueId,
                        pageNumber: state.currentPageNumber,
                      ),
                    ),
              ),
            ),
          ),
        );
      },
    );
  }
}
