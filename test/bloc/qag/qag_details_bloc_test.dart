import 'package:agora/qag/details/bloc/qag_details_bloc.dart';
import 'package:agora/qag/details/bloc/qag_details_event.dart';
import 'package:agora/qag/details/bloc/qag_details_state.dart';
import 'package:agora/qag/details/bloc/qag_details_view_model.dart';
import 'package:agora/thematique/bloc/thematique_view_model.dart';
import 'package:agora/qag/domain/qag_details.dart';
import 'package:agora/thematique/domain/thematique.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../fakes/qag/fakes_qag_repository.dart';

void main() {
  Intl.defaultLocale = "fr_FR";
  initializeDateFormatting('fr_FR', null);

  const qagId = "qagId";

  final qagDetails = QagDetails(
    id: qagId,
    thematique: Thematique(picto: "🚊", label: "Transports"),
    title: "Pour la retraite : comment est-ce qu'on aboutit au chiffre de 65 ans ?",
    description: "Le conseil d'orientation des retraites indique que les comptes sont à l'équilibre.",
    date: DateTime(2024, 1, 23),
    username: "CollectifSauvonsLaRetraite",
    canShare: true,
    canSupport: true,
    canDelete: true,
    isAuthor: true,
    support: QagDetailsSupport(count: 112, isSupported: true),
    response: QagDetailsResponse(
      author: "Olivier Véran",
      authorDescription: "Ministre délégué auprès de...",
      responseDate: DateTime(2024, 2, 20),
      videoUrl: "https://betagouv.github.io/agora-content/QaG-Stormtrooper-Response.mp4",
      videoWidth: 1080,
      videoHeight: 1920,
      transcription: "Blablabla",
      feedbackQuestion: 'feedbackQuestion',
      feedbackUserResponse: true,
      feedbackResults: QagFeedbackResults(
        positiveRatio: 79,
        negativeRatio: 21,
        count: 31415,
      ),
      additionalInfo: QagDetailsResponseAdditionalInfo(
        title: "Information complémentaires",
        description: "Description d'infos complémentaires",
      ),
    ),
    textResponse: QagDetailsTextResponse(
      responseLabel: "responseLabel",
      responseText: "responseText",
      feedbackQuestion: 'feedbackQuestion',
      feedbackUserResponse: true,
      feedbackResults: QagFeedbackResults(
        positiveRatio: 79,
        negativeRatio: 21,
        count: 31415,
      ),
    ),
  );

  final expectedViewModel = QagDetailsViewModel(
    id: qagId,
    thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
    title: "Pour la retraite : comment est-ce qu'on aboutit au chiffre de 65 ans ?",
    description: "Le conseil d'orientation des retraites indique que les comptes sont à l'équilibre.",
    date: "23 janvier",
    username: "CollectifSauvonsLaRetraite",
    canShare: true,
    canSupport: true,
    canDelete: true,
    isAuthor: true,
    support: QagDetailsSupportViewModel(count: 112, isSupported: true),
    response: QagDetailsResponseViewModel(
      author: "Olivier Véran",
      authorDescription: "Ministre délégué auprès de...",
      responseDate: "20 février 2024",
      videoUrl: "https://betagouv.github.io/agora-content/QaG-Stormtrooper-Response.mp4",
      videoWidth: 1080,
      videoHeight: 1920,
      transcription: "Blablabla",
      additionalInfo: QagDetailsResponseAdditionalInfoViewModel(
        title: "Information complémentaires",
        description: "Description d'infos complémentaires",
      ),
    ),
    feedback: QagDetailsFeedbackAnsweredResultsViewModel(
      feedbackQuestion: 'feedbackQuestion',
      userResponse: true,
      feedbackResults: QagFeedbackResults(
        positiveRatio: 79,
        negativeRatio: 21,
        count: 31415,
      ),
    ),
    textResponse: null,
  );

  group("fetchQagDetailsEvent", () {
    blocTest(
      "when repository succeed without response - should emit success state",
      build: () => QagDetailsBloc(
        qagRepository: FakeQagSuccessRepository(),
      ),
      act: (bloc) => bloc.add(FetchQagDetailsEvent(qagId: qagId)),
      expect: () => [
        QagDetailsFetchedState(
          QagDetailsViewModel(
            id: qagId,
            thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
            title: "Pour la retraite : comment est-ce qu'on aboutit au chiffre de 65 ans ?",
            description: "Le conseil d'orientation des retraites indique que les comptes sont à l'équilibre.",
            date: "23 janvier",
            username: "CollectifSauvonsLaRetraite",
            canShare: false,
            canSupport: false,
            canDelete: false,
            isAuthor: false,
            support: QagDetailsSupportViewModel(count: 112, isSupported: true),
            response: null,
            textResponse: null,
            feedback: null,
          ),
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository succeed with response - should emit success state",
      build: () => QagDetailsBloc(
        qagRepository: FakeQagSuccessWithResponseAndFeedbackGivenRepository(),
      ),
      act: (bloc) => bloc.add(FetchQagDetailsEvent(qagId: qagId)),
      expect: () => [
        QagDetailsFetchedState(
          QagDetailsViewModel(
            id: qagId,
            thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
            title: "Pour la retraite : comment est-ce qu'on aboutit au chiffre de 65 ans ?",
            description: "Le conseil d'orientation des retraites indique que les comptes sont à l'équilibre.",
            date: "23 janvier",
            username: "CollectifSauvonsLaRetraite",
            canShare: true,
            canSupport: true,
            canDelete: true,
            isAuthor: true,
            support: QagDetailsSupportViewModel(count: 112, isSupported: true),
            response: QagDetailsResponseViewModel(
              author: "Olivier Véran",
              authorDescription: "Ministre délégué auprès de...",
              responseDate: "20 février 2024",
              videoUrl: "https://betagouv.github.io/agora-content/QaG-Stormtrooper-Response.mp4",
              videoWidth: 1080,
              videoHeight: 1920,
              transcription: "Blablabla",
              additionalInfo: QagDetailsResponseAdditionalInfoViewModel(
                title: "Information complémentaires",
                description: "Description d'infos complémentaires",
              ),
            ),
            textResponse: null,
            feedback: QagDetailsFeedbackAnsweredResultsViewModel(
              feedbackQuestion: 'feedbackQuestion',
              userResponse: true,
              feedbackResults: QagFeedbackResults(
                positiveRatio: 79,
                negativeRatio: 21,
                count: 31415,
              ),
            ),
          ),
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository succeed with text response - should emit success state",
      build: () => QagDetailsBloc(
        qagRepository: FakeQagSuccessWithTextResponse(),
      ),
      act: (bloc) => bloc.add(FetchQagDetailsEvent(qagId: qagId)),
      expect: () => [
        QagDetailsFetchedState(
          QagDetailsViewModel(
            id: qagId,
            thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
            title: "Pour la retraite : comment est-ce qu'on aboutit au chiffre de 65 ans ?",
            description: "Le conseil d'orientation des retraites indique que les comptes sont à l'équilibre.",
            date: "23 janvier",
            username: "CollectifSauvonsLaRetraite",
            canShare: true,
            canSupport: true,
            canDelete: true,
            isAuthor: true,
            support: QagDetailsSupportViewModel(count: 112, isSupported: true),
            response: null,
            textResponse: QagDetailsTextResponseViewModel(
              responseLabel: "responseLabel",
              responseText: "responseText",
            ),
            feedback: QagDetailsFeedbackAnsweredResultsViewModel(
              feedbackQuestion: 'feedbackQuestionFromTextResponse',
              userResponse: true,
              feedbackResults: QagFeedbackResults(
                positiveRatio: 51,
                negativeRatio: 49,
                count: 123,
              ),
            ),
          ),
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository succeed with both video and text response - should emit success state with only video response",
      build: () => QagDetailsBloc(
        qagRepository: FakeQagSuccessWithVideoAndTextResponse(),
      ),
      act: (bloc) => bloc.add(FetchQagDetailsEvent(qagId: qagId)),
      expect: () => [
        QagDetailsFetchedState(
          QagDetailsViewModel(
            id: qagId,
            thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
            title: "Pour la retraite : comment est-ce qu'on aboutit au chiffre de 65 ans ?",
            description: "Le conseil d'orientation des retraites indique que les comptes sont à l'équilibre.",
            date: "23 janvier",
            username: "CollectifSauvonsLaRetraite",
            canShare: true,
            canSupport: true,
            canDelete: true,
            isAuthor: true,
            support: QagDetailsSupportViewModel(count: 112, isSupported: true),
            response: QagDetailsResponseViewModel(
              author: "Olivier Véran",
              authorDescription: "Ministre délégué auprès de...",
              responseDate: "20 février 2024",
              videoUrl: "https://betagouv.github.io/agora-content/QaG-Stormtrooper-Response.mp4",
              videoWidth: 1080,
              videoHeight: 1920,
              transcription: "Blablabla",
              additionalInfo: QagDetailsResponseAdditionalInfoViewModel(
                title: "Information complémentaires",
                description: "Description d'infos complémentaires",
              ),
            ),
            textResponse: null,
            feedback: QagDetailsFeedbackAnsweredResultsViewModel(
              feedbackQuestion: 'feedbackQuestion',
              userResponse: true,
              feedbackResults: QagFeedbackResults(
                positiveRatio: 79,
                negativeRatio: 21,
                count: 31415,
              ),
            ),
          ),
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed with qag moderate error - should emit failure state",
      build: () => QagDetailsBloc(
        qagRepository: FakeQagDetailsModerateFailureRepository(),
      ),
      act: (bloc) => bloc.add(FetchQagDetailsEvent(qagId: qagId)),
      expect: () => [
        QagDetailsModerateErrorState(),
      ],
      wait: const Duration(milliseconds: 5),
    );
    blocTest(
      "when repository failed - should emit failure state",
      build: () => QagDetailsBloc(
        qagRepository: FakeQagFailureRepository(),
      ),
      act: (bloc) => bloc.add(FetchQagDetailsEvent(qagId: qagId)),
      expect: () => [
        QagDetailsErrorState(),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });

  group("QaG feedback Event", () {
    blocTest(
      "when qagDetails not fetched yet - should emit nothing",
      build: () => QagDetailsBloc(
        qagRepository: FakeQagSuccessWithResponseAndFeedbackGivenRepository(),
      ),
      act: (bloc) => bloc.add(SendFeedbackQagDetailsEvent(qagId: qagId, isHelpful: true)),
      expect: () => [],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when qagDetails fetched but no response - should emit nothing",
      build: () => QagDetailsBloc(
        qagRepository: FakeQagSuccessRepository(),
      ),
      act: (bloc) => bloc
        ..add(FetchQagDetailsEvent(qagId: qagId))
        ..add(SendFeedbackQagDetailsEvent(qagId: qagId, isHelpful: true)),
      expect: () => [
        QagDetailsFetchedState(
          QagDetailsViewModel(
            id: qagId,
            thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
            title: "Pour la retraite : comment est-ce qu'on aboutit au chiffre de 65 ans ?",
            description: "Le conseil d'orientation des retraites indique que les comptes sont à l'équilibre.",
            date: "23 janvier",
            username: "CollectifSauvonsLaRetraite",
            canShare: false,
            canSupport: false,
            canDelete: false,
            isAuthor: false,
            support: QagDetailsSupportViewModel(count: 112, isSupported: true),
            response: null,
            textResponse: null,
            feedback: null,
          ),
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when qagDetails fetched, has response but already given feedback - should emit nothing",
      build: () => QagDetailsBloc(
        qagRepository: FakeQagDetailsSuccessRepository(
          qagDetails: QagDetails.copyWithNewResponse(
            qagDetails: qagDetails,
            response: QagDetailsResponse.copyWithNewFeedback(
              response: qagDetails.response!,
              feedbackUserResponse: true,
              feedbackResults: qagDetails.response!.feedbackResults,
            ),
          ),
        ),
      ),
      act: (bloc) => bloc
        ..add(FetchQagDetailsEvent(qagId: qagId))
        ..add(SendFeedbackQagDetailsEvent(qagId: qagId, isHelpful: true)),
      expect: () => [
        QagDetailsFetchedState(expectedViewModel),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when qagDetails fetched, has not given feedback but repository failure - should emit error",
      build: () => QagDetailsBloc(
        feedbackLoadingDuration: const Duration(milliseconds: 0),
        qagRepository: FakeQagDetailsSuccessAndFeedbackFailureRepository(
          qagDetails: QagDetails.copyWithNewResponse(
            qagDetails: qagDetails,
            response: QagDetailsResponse.copyWithNewFeedback(
              response: qagDetails.response!,
              feedbackUserResponse: null,
              feedbackResults: null,
            ),
          ),
        ),
      ),
      act: (bloc) => bloc
        ..add(FetchQagDetailsEvent(qagId: qagId))
        ..add(SendFeedbackQagDetailsEvent(qagId: qagId, isHelpful: true)),
      expect: () => [
        QagDetailsFetchedState(
          QagDetailsViewModel.copyWithNewFeedback(
            viewModel: expectedViewModel,
            feedback: QagDetailsFeedbackNotAnsweredViewModel(
              feedbackQuestion: 'feedbackQuestion',
              previousUserResponse: null,
              previousFeedbackResults: null,
            ),
          ),
        ),
        QagDetailsFetchedState(
          QagDetailsViewModel.copyWithNewFeedback(
            viewModel: expectedViewModel,
            feedback: QagDetailsFeedbackLoadingViewModel(
              feedbackQuestion: 'feedbackQuestion',
              isHelpfulClicked: true,
            ),
          ),
        ),
        QagDetailsFetchedState(
          QagDetailsViewModel.copyWithNewFeedback(
            viewModel: expectedViewModel,
            feedback: QagDetailsFeedbackErrorViewModel(feedbackQuestion: 'feedbackQuestion'),
          ),
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when qagDetails fetched, has not given feedback and repository succeed - should emit success state with loading then answered",
      build: () => QagDetailsBloc(
        feedbackLoadingDuration: const Duration(milliseconds: 0),
        qagRepository: FakeQagDetailsSuccessRepository(
          qagDetails: QagDetails.copyWithNewResponse(
            qagDetails: qagDetails,
            response: QagDetailsResponse.copyWithNewFeedback(
              response: qagDetails.response!,
              feedbackUserResponse: null,
              feedbackResults: null,
            ),
          ),
        ),
      ),
      act: (bloc) => bloc
        ..add(FetchQagDetailsEvent(qagId: qagId))
        ..add(SendFeedbackQagDetailsEvent(qagId: qagId, isHelpful: false)),
      expect: () => [
        QagDetailsFetchedState(
          QagDetailsViewModel.copyWithNewFeedback(
            viewModel: expectedViewModel,
            feedback: QagDetailsFeedbackNotAnsweredViewModel(
              feedbackQuestion: 'feedbackQuestion',
              previousUserResponse: null,
              previousFeedbackResults: null,
            ),
          ),
        ),
        QagDetailsFetchedState(
          QagDetailsViewModel.copyWithNewFeedback(
            viewModel: expectedViewModel,
            feedback: QagDetailsFeedbackLoadingViewModel(
              feedbackQuestion: 'feedbackQuestion',
              isHelpfulClicked: false,
            ),
          ),
        ),
        QagDetailsFetchedState(
          QagDetailsViewModel.copyWithNewFeedback(
            viewModel: expectedViewModel,
            feedback: QagDetailsFeedbackAnsweredResultsViewModel(
              feedbackQuestion: 'feedbackQuestion',
              userResponse: false,
              feedbackResults: QagFeedbackResults(
                positiveRatio: 79,
                negativeRatio: 21,
                count: 31415,
              ),
            ),
          ),
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when qagDetails fetched, has response, answered feedback then change it to the same value - should emit answered without loading and without sending feedback with repository",
      build: () => QagDetailsBloc(
        qagRepository: FakeQagDetailsSuccessRepository(
          remainingSendFeedbackCount: 0,
          qagDetails: QagDetails.copyWithNewResponse(
            qagDetails: qagDetails,
            response: QagDetailsResponse.copyWithNewFeedback(
              response: qagDetails.response!,
              feedbackUserResponse: true,
              feedbackResults: QagFeedbackResults(
                positiveRatio: 79,
                negativeRatio: 21,
                count: 31415,
              ),
            ),
          ),
        ),
      ),
      act: (bloc) => bloc
        ..add(FetchQagDetailsEvent(qagId: qagId))
        ..add(EditFeedbackQagDetailsEvent())
        ..add(SendFeedbackQagDetailsEvent(qagId: qagId, isHelpful: true)),
      expect: () => [
        QagDetailsFetchedState(
          QagDetailsViewModel.copyWithNewFeedback(
            viewModel: expectedViewModel,
            feedback: QagDetailsFeedbackAnsweredResultsViewModel(
              feedbackQuestion: "feedbackQuestion",
              userResponse: true,
              feedbackResults: QagFeedbackResults(
                positiveRatio: 79,
                negativeRatio: 21,
                count: 31415,
              ),
            ),
          ),
        ),
        QagDetailsFetchedState(
          QagDetailsViewModel.copyWithNewFeedback(
            viewModel: expectedViewModel,
            feedback: QagDetailsFeedbackNotAnsweredViewModel(
              feedbackQuestion: "feedbackQuestion",
              previousUserResponse: true,
              previousFeedbackResults: QagFeedbackResults(
                positiveRatio: 79,
                negativeRatio: 21,
                count: 31415,
              ),
            ),
          ),
        ),
        QagDetailsFetchedState(
          QagDetailsViewModel.copyWithNewFeedback(
            viewModel: expectedViewModel,
            feedback: QagDetailsFeedbackAnsweredResultsViewModel(
              feedbackQuestion: "feedbackQuestion",
              userResponse: true,
              feedbackResults: QagFeedbackResults(
                positiveRatio: 79,
                negativeRatio: 21,
                count: 31415,
              ),
            ),
          ),
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });

  group("QaG edit feedback Event", () {
    blocTest(
      "when qagDetails not fetched yet - should emit nothing",
      build: () => QagDetailsBloc(
        qagRepository: FakeQagSuccessWithResponseAndFeedbackGivenRepository(),
      ),
      act: (bloc) => bloc.add(EditFeedbackQagDetailsEvent()),
      expect: () => [],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when qagDetails fetched but no response - should emit nothing",
      build: () => QagDetailsBloc(
        qagRepository: FakeQagSuccessRepository(),
      ),
      act: (bloc) => bloc
        ..add(FetchQagDetailsEvent(qagId: qagId))
        ..add(EditFeedbackQagDetailsEvent()),
      expect: () => [
        QagDetailsFetchedState(
          QagDetailsViewModel(
            id: qagId,
            thematique: ThematiqueViewModel(picto: "🚊", label: "Transports"),
            title: "Pour la retraite : comment est-ce qu'on aboutit au chiffre de 65 ans ?",
            description: "Le conseil d'orientation des retraites indique que les comptes sont à l'équilibre.",
            date: "23 janvier",
            username: "CollectifSauvonsLaRetraite",
            canShare: false,
            canSupport: false,
            canDelete: false,
            isAuthor: false,
            support: QagDetailsSupportViewModel(count: 112, isSupported: true),
            response: null,
            textResponse: null,
            feedback: null,
          ),
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when qagDetails fetched, has response but not answered feedback yet - should emit nothing",
      build: () => QagDetailsBloc(
        qagRepository: FakeQagDetailsSuccessRepository(
          qagDetails: QagDetails.copyWithNewResponse(
            qagDetails: qagDetails,
            response: QagDetailsResponse.copyWithNewFeedback(
              response: qagDetails.response!,
              feedbackUserResponse: null,
              feedbackResults: null,
            ),
          ),
        ),
      ),
      act: (bloc) => bloc
        ..add(FetchQagDetailsEvent(qagId: qagId))
        ..add(EditFeedbackQagDetailsEvent()),
      expect: () => [
        QagDetailsFetchedState(
          QagDetailsViewModel.copyWithNewFeedback(
            viewModel: expectedViewModel,
            feedback: QagDetailsFeedbackNotAnsweredViewModel(
              feedbackQuestion: "feedbackQuestion",
              previousUserResponse: null,
              previousFeedbackResults: null,
            ),
          ),
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when qagDetails fetched, has response, no results and answered feedback - should emit not answered",
      build: () => QagDetailsBloc(
        qagRepository: FakeQagDetailsSuccessRepository(
          qagDetails: QagDetails.copyWithNewResponse(
            qagDetails: qagDetails,
            response: QagDetailsResponse.copyWithNewFeedback(
              response: qagDetails.response!,
              feedbackUserResponse: false,
              feedbackResults: null,
            ),
          ),
        ),
      ),
      act: (bloc) => bloc
        ..add(FetchQagDetailsEvent(qagId: qagId))
        ..add(EditFeedbackQagDetailsEvent()),
      expect: () => [
        QagDetailsFetchedState(
          QagDetailsViewModel.copyWithNewFeedback(
            viewModel: expectedViewModel,
            feedback: QagDetailsFeedbackAnsweredNoResultsViewModel(
              feedbackQuestion: "feedbackQuestion",
              userResponse: false,
            ),
          ),
        ),
        QagDetailsFetchedState(
          QagDetailsViewModel.copyWithNewFeedback(
            viewModel: expectedViewModel,
            feedback: QagDetailsFeedbackNotAnsweredViewModel(
              feedbackQuestion: "feedbackQuestion",
              previousUserResponse: false,
              previousFeedbackResults: null,
            ),
          ),
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when qagDetails fetched, has response, no results and answered feedback - should emit not answered",
      build: () => QagDetailsBloc(
        qagRepository: FakeQagDetailsSuccessRepository(
          qagDetails: QagDetails.copyWithNewResponse(
            qagDetails: qagDetails,
            response: QagDetailsResponse.copyWithNewFeedback(
              response: qagDetails.response!,
              feedbackUserResponse: true,
              feedbackResults: QagFeedbackResults(
                positiveRatio: 79,
                negativeRatio: 21,
                count: 31415,
              ),
            ),
          ),
        ),
      ),
      act: (bloc) => bloc
        ..add(FetchQagDetailsEvent(qagId: qagId))
        ..add(EditFeedbackQagDetailsEvent()),
      expect: () => [
        QagDetailsFetchedState(
          QagDetailsViewModel.copyWithNewFeedback(
            viewModel: expectedViewModel,
            feedback: QagDetailsFeedbackAnsweredResultsViewModel(
              feedbackQuestion: "feedbackQuestion",
              userResponse: true,
              feedbackResults: QagFeedbackResults(
                positiveRatio: 79,
                negativeRatio: 21,
                count: 31415,
              ),
            ),
          ),
        ),
        QagDetailsFetchedState(
          QagDetailsViewModel.copyWithNewFeedback(
            viewModel: expectedViewModel,
            feedback: QagDetailsFeedbackNotAnsweredViewModel(
              feedbackQuestion: "feedbackQuestion",
              previousUserResponse: true,
              previousFeedbackResults: QagFeedbackResults(
                positiveRatio: 79,
                negativeRatio: 21,
                count: 31415,
              ),
            ),
          ),
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
