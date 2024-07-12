import 'package:agora/qag/moderation/bloc/list/qag_moderation_list_bloc.dart';
import 'package:agora/qag/moderation/bloc/list/qag_moderation_list_event.dart';
import 'package:agora/qag/moderation/bloc/list/qag_moderation_list_state.dart';
import 'package:agora/qag/moderation/bloc/list/qag_moderation_list_view_model.dart';
import 'package:agora/thematique/bloc/thematique_view_model.dart';
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

  group("RemoveFromQagModerationListEvent", () {
    blocTest<QagModerationListBloc, QagModerationListState>(
      "when remove qag with specific id exist from list - should emit success state with new list",
      build: () => QagModerationListBloc(
        qagRepository: FakeQagSuccessRepository(),
      ),
      seed: () => QagModerationListSuccessState(
        QagModerationListViewModel(
          totalNumber: 120,
          qagsToModerationViewModels: [
            QagModerationViewModel(
              id: "qagId1",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "title1",
              description: "description1",
              username: "username1",
              date: "23 avril",
              supportCount: 10,
              isSupported: false,
            ),
            QagModerationViewModel(
              id: "qagId",
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
      act: (bloc) => bloc.add(RemoveFromQagModerationListEvent(qagId: "qagId")),
      expect: () => [
        QagModerationListSuccessState(
          QagModerationListViewModel(
            totalNumber: 119,
            qagsToModerationViewModels: [
              QagModerationViewModel(
                id: "qagId1",
                thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
                title: "title1",
                description: "description1",
                username: "username1",
                date: "23 avril",
                supportCount: 10,
                isSupported: false,
              ),
            ],
          ),
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<QagModerationListBloc, QagModerationListState>(
      "when remove qag with specific id NOT exist from list - should emit success state",
      build: () => QagModerationListBloc(
        qagRepository: FakeQagSuccessRepository(),
      ),
      seed: () => QagModerationListSuccessState(
        QagModerationListViewModel(
          totalNumber: 120,
          qagsToModerationViewModels: [
            QagModerationViewModel(
              id: "qagId",
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
      act: (bloc) => bloc.add(RemoveFromQagModerationListEvent(qagId: "qagIdNotExist")),
      expect: () => [
        // state should not changed
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
