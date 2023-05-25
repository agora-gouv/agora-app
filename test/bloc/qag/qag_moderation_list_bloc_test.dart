import 'package:agora/bloc/qag/moderation/list/qag_moderation_list_bloc.dart';
import 'package:agora/bloc/qag/moderation/list/qag_moderation_list_event.dart';
import 'package:agora/bloc/qag/moderation/list/qag_moderation_list_state.dart';
import 'package:agora/bloc/qag/moderation/list/qag_moderation_list_view_model.dart';
import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../fakes/qag/fakes_qag_repository.dart';

void main() {
  Intl.defaultLocale = "fr_FR";
  initializeDateFormatting('fr_FR', null);

  group("FetchQagModerationListEvent", () {
    blocTest(
      "when repository succeed - should emit success state",
      build: () => QagModerationListBloc(
        qagRepository: FakeQagSuccessRepository(),
      ),
      act: (bloc) => bloc.add(FetchQagModerationListEvent()),
      expect: () => [
        QagModerationListLoadingState(),
        QagModerationListSuccessState(
          QagModerationListViewModel(
            totalNumber: 120,
            qagsToModerationViewModels: [
              QagModerationViewModel(
                id: "id",
                thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
                title: "title",
                description: "description",
                username: "username",
                date: "23 avril",
                supportCount: 9,
                isSupported: true,
              ),
            ],
          ),
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed - should emit failure state",
      build: () => QagModerationListBloc(
        qagRepository: FakeQagFailureRepository(),
      ),
      act: (bloc) => bloc.add(FetchQagModerationListEvent()),
      expect: () => [
        QagModerationListLoadingState(),
        QagModerationListErrorState(),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
