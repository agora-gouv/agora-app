import 'package:agora/bloc/qag/qag_bloc.dart';
import 'package:agora/bloc/qag/qag_event.dart';
import 'package:agora/bloc/qag/qag_state.dart';
import 'package:agora/bloc/qag/qag_view_model.dart';
import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:agora/domain/qag/qags_error_type.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../fakes/qag/fakes_qag_repository.dart';

void main() {
  Intl.defaultLocale = "fr_FR";
  initializeDateFormatting('fr_FR', null);

  group("FetchQagsEvent", () {
    blocTest(
      "when repository succeed - should emit success state",
      build: () => QagBloc(
        qagRepository: FakeQagSuccessRepository(),
      ),
      act: (bloc) => bloc.add(FetchQagsEvent(thematiqueId: null)),
      expect: () => [
        QagFetchedState(
          popularViewModels: [
            QagViewModel(
              id: "id1",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "title1",
              username: "username1",
              date: "23 janvier",
              supportCount: 7,
              isSupported: true,
              isAuthor: true,
            ),
          ],
          latestViewModels: [
            QagViewModel(
              id: "id2",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "title2",
              username: "username2",
              date: "23 février",
              supportCount: 8,
              isSupported: false,
              isAuthor: false,
            ),
          ],
          supportingViewModels: [
            QagViewModel(
              id: "id3",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "title3",
              username: "username3",
              date: "23 mars",
              supportCount: 9,
              isSupported: true,
              isAuthor: false,
            ),
          ],
          errorCase: null,
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository succeed with ask question error message - should emit success state",
      build: () => QagBloc(
        qagRepository: FakeQagSuccessWithAskQuestionErrorMessageRepository(),
      ),
      act: (bloc) => bloc.add(FetchQagsEvent(thematiqueId: null)),
      expect: () => [
        QagFetchedState(
          popularViewModels: [
            QagViewModel(
              id: "id1",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "title1",
              username: "username1",
              date: "23 janvier",
              supportCount: 7,
              isSupported: true,
              isAuthor: true,
            ),
          ],
          latestViewModels: [
            QagViewModel(
              id: "id2",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "title2",
              username: "username2",
              date: "23 février",
              supportCount: 8,
              isSupported: false,
              isAuthor: false,
            ),
          ],
          supportingViewModels: [
            QagViewModel(
              id: "id3",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "title3",
              username: "username3",
              date: "23 mars",
              supportCount: 9,
              isSupported: true,
              isAuthor: false,
            ),
          ],
          errorCase: "Une erreur est survenue",
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<QagBloc, QagState>(
      "when repository succeed with already existing qag in state - should emit success state",
      build: () => QagBloc(
        qagRepository: FakeQagSuccessRepository(),
      ),
      seed: () => QagFetchedState(
        popularViewModels: [
          QagViewModel(
            id: "",
            thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
            title: "",
            username: "",
            date: "",
            supportCount: 7,
            isSupported: true,
            isAuthor: false,
          ),
        ],
        latestViewModels: [
          QagViewModel(
            id: "",
            thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
            title: "",
            username: "",
            date: "",
            supportCount: 8,
            isSupported: false,
            isAuthor: false,
          ),
        ],
        supportingViewModels: [
          QagViewModel(
            id: "",
            thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
            title: "",
            username: "",
            date: "",
            supportCount: 9,
            isSupported: true,
            isAuthor: false,
          ),
        ],
        errorCase: null,
      ),
      act: (bloc) => bloc.add(FetchQagsEvent(thematiqueId: null)),
      expect: () => [
        QagLoadingState(
          popularViewModels: [],
          latestViewModels: [],
          supportingViewModels: [],
          errorCase: null,
        ),
        QagFetchedState(
          popularViewModels: [
            QagViewModel(
              id: "id1",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "title1",
              username: "username1",
              date: "23 janvier",
              supportCount: 7,
              isSupported: true,
              isAuthor: true,
            ),
          ],
          latestViewModels: [
            QagViewModel(
              id: "id2",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "title2",
              username: "username2",
              date: "23 février",
              supportCount: 8,
              isSupported: false,
              isAuthor: false,
            ),
          ],
          supportingViewModels: [
            QagViewModel(
              id: "id3",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "title3",
              username: "username3",
              date: "23 mars",
              supportCount: 9,
              isSupported: true,
              isAuthor: false,
            ),
          ],
          errorCase: null,
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed with timeout - should emit failure state",
      build: () => QagBloc(
        qagRepository: FakeQagTimeoutFailureRepository(),
      ),
      act: (bloc) => bloc.add(FetchQagsEvent(thematiqueId: "thematiqueId")),
      expect: () => [
        QagErrorState(errorType: QagsErrorType.timeout),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed - should emit failure state",
      build: () => QagBloc(
        qagRepository: FakeQagFailureRepository(),
      ),
      act: (bloc) => bloc.add(FetchQagsEvent(thematiqueId: "anotherThematiqueId")),
      expect: () => [
        QagErrorState(errorType: QagsErrorType.generic),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });

  group("UpdateQagsEvent", () {
    blocTest<QagBloc, QagState>(
      "when add support to qags - should emit updated state",
      build: () => QagBloc(
        qagRepository: FakeQagSuccessRepository(),
      ),
      seed: () => QagFetchedState(
        popularViewModels: [
          QagViewModel(
            id: "id0",
            thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
            title: "title0",
            username: "username0",
            date: "23 janvier",
            supportCount: 8,
            isSupported: true,
            isAuthor: false,
          ),
        ],
        latestViewModels: [
          QagViewModel(
            id: "id1",
            thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
            title: "title1",
            username: "username1",
            date: "23 février",
            supportCount: 6,
            isSupported: false,
            isAuthor: true,
          ),
        ],
        supportingViewModels: [
          QagViewModel(
            id: "id0",
            thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
            title: "title0",
            username: "username0",
            date: "23 janvier",
            supportCount: 8,
            isSupported: true,
            isAuthor: false,
          ),
        ],
        errorCase: null,
      ),
      act: (bloc) => bloc.add(
        UpdateQagsEvent(
          qagId: "id1",
          thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
          title: "title1",
          username: "username1",
          date: "23 février",
          supportCount: 7,
          isSupported: true,
          isAuthor: false,
        ),
      ),
      expect: () => [
        QagFetchedState(
          popularViewModels: [
            QagViewModel(
              id: "id0",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "title0",
              username: "username0",
              date: "23 janvier",
              supportCount: 8,
              isSupported: true,
              isAuthor: false,
            ),
          ],
          latestViewModels: [
            QagViewModel(
              id: "id1",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "title1",
              username: "username1",
              date: "23 février",
              supportCount: 7,
              isSupported: true,
              isAuthor: true,
            ),
          ],
          supportingViewModels: [
            QagViewModel(
              id: "id1",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "title1",
              username: "username1",
              date: "23 février",
              supportCount: 7,
              isSupported: true,
              isAuthor: false,
            ),
            QagViewModel(
              id: "id0",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "title0",
              username: "username0",
              date: "23 janvier",
              supportCount: 8,
              isSupported: true,
              isAuthor: false,
            ),
          ],
          errorCase: null,
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<QagBloc, QagState>(
      "when delete support to qags - should emit updated state",
      build: () => QagBloc(
        qagRepository: FakeQagSuccessRepository(),
      ),
      seed: () => QagFetchedState(
        popularViewModels: [
          QagViewModel(
            id: "id0",
            thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
            title: "title0",
            username: "username0",
            date: "23 janvier",
            supportCount: 7,
            isSupported: true,
            isAuthor: true,
          ),
          QagViewModel(
            id: "id1",
            thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
            title: "title1",
            username: "username1",
            date: "23 février",
            supportCount: 7,
            isSupported: true,
            isAuthor: true,
          ),
        ],
        latestViewModels: [],
        supportingViewModels: [
          QagViewModel(
            id: "id1",
            thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
            title: "title1",
            username: "username1",
            date: "23 février",
            supportCount: 7,
            isSupported: true,
            isAuthor: true,
          ),
        ],
        errorCase: null,
      ),
      act: (bloc) => bloc.add(
        UpdateQagsEvent(
          qagId: "id1",
          thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
          title: "title1",
          username: "username1",
          date: "23 février",
          supportCount: 6,
          isSupported: false,
          isAuthor: true,
        ),
      ),
      expect: () => [
        QagFetchedState(
          popularViewModels: [
            QagViewModel(
              id: "id0",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "title0",
              username: "username0",
              date: "23 janvier",
              supportCount: 7,
              isSupported: true,
              isAuthor: true,
            ),
            QagViewModel(
              id: "id1",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "title1",
              username: "username1",
              date: "23 février",
              supportCount: 6,
              isSupported: false,
              isAuthor: true,
            ),
          ],
          latestViewModels: [],
          supportingViewModels: [],
          errorCase: null,
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<QagBloc, QagState>(
      "when update support to supported qags - should emit updated state",
      build: () => QagBloc(
        qagRepository: FakeQagSuccessRepository(),
      ),
      seed: () => QagFetchedState(
        popularViewModels: [
          QagViewModel(
            id: "id0",
            thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
            title: "title0",
            username: "username0",
            date: "23 janvier",
            supportCount: 7,
            isSupported: false,
            isAuthor: false,
          ),
        ],
        latestViewModels: [
          QagViewModel(
            id: "id0",
            thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
            title: "title0",
            username: "username0",
            date: "23 janvier",
            supportCount: 7,
            isSupported: false,
            isAuthor: false,
          ),
        ],
        supportingViewModels: [
          QagViewModel(
            id: "id0",
            thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
            title: "title0",
            username: "username0",
            date: "23 janvier",
            supportCount: 7,
            isSupported: false,
            isAuthor: false,
          ),
        ],
        errorCase: null,
      ),
      act: (bloc) => bloc.add(
        UpdateQagsEvent(
          qagId: "id0",
          thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
          title: "title0",
          username: "username0",
          date: "23 janvier",
          supportCount: 8,
          isSupported: true,
          isAuthor: false,
        ),
      ),
      expect: () => [
        QagFetchedState(
          popularViewModels: [
            QagViewModel(
              id: "id0",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "title0",
              username: "username0",
              date: "23 janvier",
              supportCount: 8,
              isSupported: true,
              isAuthor: false,
            ),
          ],
          latestViewModels: [
            QagViewModel(
              id: "id0",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "title0",
              username: "username0",
              date: "23 janvier",
              supportCount: 8,
              isSupported: true,
              isAuthor: false,
            ),
          ],
          supportingViewModels: [
            QagViewModel(
              id: "id0",
              thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
              title: "title0",
              username: "username0",
              date: "23 janvier",
              supportCount: 8,
              isSupported: true,
              isAuthor: false,
            ),
          ],
          errorCase: null,
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
