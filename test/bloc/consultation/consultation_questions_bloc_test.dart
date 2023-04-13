import 'package:agora/bloc/consultation/question/consultation_questions_bloc.dart';
import 'package:agora/bloc/consultation/question/consultation_questions_event.dart';
import 'package:agora/bloc/consultation/question/consultation_questions_state.dart';
import 'package:agora/bloc/consultation/question/consultation_questions_view_model.dart';
import 'package:agora/domain/consultation/questions/consultation_question_type.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/consultation/fakes_consultation_repository.dart';

void main() {
  const consultationId = "consultationId";

  final responseChoiceViewModelsSortedByOrder = [
    ConsultationQuestionViewModel(
      id: "questionIdA",
      label: "Comment vous rendez-vous généralement sur votre lieu de travail ?",
      order: 1,
      type: ConsultationQuestionType.unique,
      maxChoices: null,
      responseChoicesViewModels: [
        ConsultationQuestionResponseChoiceViewModel(id: "choiceA", label: "En vélo ou à pied", order: 1),
        ConsultationQuestionResponseChoiceViewModel(id: "choiceC", label: "En transports en commun", order: 2),
      ],
    ),
    ConsultationQuestionViewModel(
      id: "questionIdB",
      label: "Si vous vous lancez dans le co-voiturage, ...",
      order: 2,
      type: ConsultationQuestionType.unique,
      maxChoices: null,
      responseChoicesViewModels: [
        ConsultationQuestionResponseChoiceViewModel(id: "choiceBB", label: "oui", order: 1),
        ConsultationQuestionResponseChoiceViewModel(id: "choiceAA", label: "non", order: 2),
      ],
    ),
    ConsultationQuestionViewModel(
      id: "questionIdC",
      label: "Question C ?",
      order: 3,
      type: ConsultationQuestionType.multiple,
      maxChoices: 2,
      responseChoicesViewModels: [
        ConsultationQuestionResponseChoiceViewModel(id: "choiceAAA", label: "En vélo ou à pied", order: 1),
        ConsultationQuestionResponseChoiceViewModel(id: "choiceBBB", label: "En voiture", order: 2),
        ConsultationQuestionResponseChoiceViewModel(id: "choiceCCC", label: "En transports en commun", order: 3),
      ],
    ),
  ];
  final expectedTotalQuestion = responseChoiceViewModelsSortedByOrder.length;

  group("FetchConsultationQuestionsEvent", () {
    blocTest(
      "when repository succeed - should emit success state",
      build: () => ConsultationQuestionsBloc(consultationRepository: FakeConsultationSuccessRepository()),
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
      "when repository failed - should emit failure state",
      build: () => ConsultationQuestionsBloc(consultationRepository: FakeConsultationFailureRepository()),
      act: (bloc) => bloc.add(FetchConsultationQuestionsEvent(consultationId: consultationId)),
      expect: () => [
        ConsultationQuestionsErrorState(),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });

  group("ConsultationNextQuestionEvent", () {
    blocTest(
      "when next question - should update index to currentQuestionIndex + 1",
      build: () => ConsultationQuestionsBloc(consultationRepository: FakeConsultationSuccessRepository()),
      act: (bloc) => bloc
        ..add(FetchConsultationQuestionsEvent(consultationId: consultationId))
        ..add(ConsultationNextQuestionEvent()),
      skip: 1,
      expect: () => [
        ConsultationQuestionsFetchedState(
          currentQuestionIndex: 1,
          totalQuestion: expectedTotalQuestion,
          viewModels: responseChoiceViewModelsSortedByOrder,
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when next question index is equals to total question - should update to finish question state",
      build: () => ConsultationQuestionsBloc(consultationRepository: FakeConsultationSuccessRepository()),
      act: (bloc) => bloc
        ..add(FetchConsultationQuestionsEvent(consultationId: consultationId))
        ..add(ConsultationNextQuestionEvent())
        ..add(ConsultationNextQuestionEvent())
        ..add(ConsultationNextQuestionEvent()),
      skip: expectedTotalQuestion,
      expect: () => [
        ConsultationQuestionsFinishState(),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });

  group("ConsultationPreviousQuestionEvent", () {
    blocTest(
      "when previous question - should update currentQuestionIndex - 1",
      build: () => ConsultationQuestionsBloc(consultationRepository: FakeConsultationSuccessRepository()),
      act: (bloc) => bloc
        ..add(FetchConsultationQuestionsEvent(consultationId: consultationId))
        ..add(ConsultationNextQuestionEvent())
        ..add(ConsultationPreviousQuestionEvent()),
      skip: 2,
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
