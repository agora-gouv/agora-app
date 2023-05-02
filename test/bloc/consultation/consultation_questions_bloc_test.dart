import 'package:agora/bloc/consultation/question/consultation_questions_bloc.dart';
import 'package:agora/bloc/consultation/question/consultation_questions_event.dart';
import 'package:agora/bloc/consultation/question/consultation_questions_state.dart';
import 'package:agora/bloc/consultation/question/consultation_questions_view_model.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/consultation/fakes_consultation_repository.dart';
import '../../fakes/qag/fake_device_id_helper.dart';

void main() {
  const consultationId = "consultationId";

  final responseChoiceViewModelsSortedByOrder = [
    ConsultationQuestionMultipleViewModel(
      id: "questionIdA",
      title: "Comment vous rendez-vous généralement sur votre lieu de travail ?",
      order: 1,
      questionProgress: "Question 1/3",
      maxChoices: 2,
      responseChoicesViewModels: [
        ConsultationQuestionResponseChoiceViewModel(id: "choiceB", label: "En voiture", order: 1),
        ConsultationQuestionResponseChoiceViewModel(id: "choiceC", label: "En transports en commun", order: 2),
        ConsultationQuestionResponseChoiceViewModel(id: "choiceA", label: "En vélo ou à pied", order: 3),
      ],
    ),
    ConsultationQuestionUniqueViewModel(
      id: "questionIdB",
      title: "Si vous vous lancez dans le co-voiturage, ...",
      order: 2,
      questionProgress: "Question 2/3",
      responseChoicesViewModels: [
        ConsultationQuestionResponseChoiceViewModel(id: "choiceBB", label: "oui", order: 1),
        ConsultationQuestionResponseChoiceViewModel(id: "choiceAA", label: "non", order: 2),
      ],
    ),
    ConsultationQuestionChapterViewModel(
      id: "chapiter1",
      title: "titre du chapitre",
      order: 3,
      description: "description du chapitre",
    ),
    ConsultationQuestionOpenedViewModel(
      id: "questionIdC",
      title: "Question C ?",
      order: 4,
      questionProgress: "Question 3/3",
    ),
  ];
  final expectedTotalQuestion = responseChoiceViewModelsSortedByOrder.length;

  group("FetchConsultationQuestionsEvent", () {
    blocTest(
      "when repository succeed - should emit success state",
      build: () => ConsultationQuestionsBloc(
        consultationRepository: FakeConsultationSuccessRepository(),
        deviceInfoHelper: FakeDeviceInfoHelper(),
      ),
      act: (bloc) => bloc.add(FetchConsultationQuestionsEvent(consultationId: consultationId)),
      expect: () => [
        ConsultationQuestionsFetchedState(
          currentQuestionIndex: 0,
          totalQuestion: expectedTotalQuestion,
          viewModels: responseChoiceViewModelsSortedByOrder,
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when device id is null - should emit failure state",
      build: () => ConsultationQuestionsBloc(
        consultationRepository: FakeConsultationSuccessRepository(),
        deviceInfoHelper: FakeDeviceIdNullHelper(),
      ),
      act: (bloc) => bloc.add(FetchConsultationQuestionsEvent(consultationId: consultationId)),
      expect: () => [
        ConsultationQuestionsErrorState(),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed - should emit failure state",
      build: () => ConsultationQuestionsBloc(
        consultationRepository: FakeConsultationFailureRepository(),
        deviceInfoHelper: FakeDeviceInfoHelper(),
      ),
      act: (bloc) => bloc.add(FetchConsultationQuestionsEvent(consultationId: consultationId)),
      expect: () => [
        ConsultationQuestionsErrorState(),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });

  group("ConsultationNextQuestionEvent", () {
    blocTest<ConsultationQuestionsBloc, ConsultationQuestionsState>(
      "when next question - should update index to currentQuestionIndex + 1",
      build: () => ConsultationQuestionsBloc(
        consultationRepository: FakeConsultationSuccessRepository(),
        deviceInfoHelper: FakeDeviceInfoHelper(),
      ),
      seed: () => ConsultationQuestionsFetchedState(
        currentQuestionIndex: 0,
        totalQuestion: expectedTotalQuestion,
        viewModels: responseChoiceViewModelsSortedByOrder,
      ),
      act: (bloc) => bloc.add(ConsultationNextQuestionEvent()),
      expect: () => [
        ConsultationQuestionsFetchedState(
          currentQuestionIndex: 1,
          totalQuestion: expectedTotalQuestion,
          viewModels: responseChoiceViewModelsSortedByOrder,
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<ConsultationQuestionsBloc, ConsultationQuestionsState>(
      "when next question index is equals to total question - should update to finish question state",
      build: () => ConsultationQuestionsBloc(
        consultationRepository: FakeConsultationSuccessRepository(),
        deviceInfoHelper: FakeDeviceInfoHelper(),
      ),
      seed: () => ConsultationQuestionsFetchedState(
        currentQuestionIndex: 3,
        totalQuestion: expectedTotalQuestion,
        viewModels: responseChoiceViewModelsSortedByOrder,
      ),
      act: (bloc) => bloc.add(ConsultationNextQuestionEvent()),
      expect: () => [
        ConsultationQuestionsFinishState(),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });

  group("ConsultationPreviousQuestionEvent", () {
    blocTest<ConsultationQuestionsBloc, ConsultationQuestionsState>(
      "when previous question - should update currentQuestionIndex - 1",
      build: () => ConsultationQuestionsBloc(
        consultationRepository: FakeConsultationSuccessRepository(),
        deviceInfoHelper: FakeDeviceInfoHelper(),
      ),
      seed: () => ConsultationQuestionsFetchedState(
        currentQuestionIndex: 1,
        totalQuestion: expectedTotalQuestion,
        viewModels: responseChoiceViewModelsSortedByOrder,
      ),
      act: (bloc) => bloc.add(ConsultationPreviousQuestionEvent()),
      expect: () => [
        ConsultationQuestionsFetchedState(
          currentQuestionIndex: 0,
          totalQuestion: expectedTotalQuestion,
          viewModels: responseChoiceViewModelsSortedByOrder,
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
