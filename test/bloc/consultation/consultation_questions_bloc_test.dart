import 'package:agora/bloc/consultation/question/consultation_questions_action.dart';
import 'package:agora/bloc/consultation/question/consultation_questions_bloc.dart';
import 'package:agora/bloc/consultation/question/consultation_questions_state.dart';
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
      responseChoicesViewModels: [
        ConsultationQuestionResponseChoiceViewModel(id: "choiceBB", label: "oui", order: 1),
        ConsultationQuestionResponseChoiceViewModel(id: "choiceAA", label: "non", order: 2),
      ],
    ),
  ];

  group("FetchConsultationQuestionsEvent", () {
    blocTest(
      "when repository succeed - should emit success state",
      build: () => ConsultationQuestionsBloc(consultationRepository: FakeConsultationSuccessRepository()),
      act: (bloc) => bloc.add(FetchConsultationQuestionsEvent(consultationId: consultationId)),
      expect: () => [
        ConsultationQuestionsLoadingState(),
        ConsultationQuestionsFetchedState(
          currentQuestionIndex: 0,
          totalQuestion: 2,
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
        ConsultationQuestionsLoadingState(),
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
      skip: 2,
      expect: () => [
        ConsultationQuestionsFetchedState(
          currentQuestionIndex: 1,
          totalQuestion: 2,
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
        ..add(ConsultationNextQuestionEvent()),
      skip: 3,
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
      skip: 3,
      expect: () => [
        ConsultationQuestionsFetchedState(
          currentQuestionIndex: 0,
          totalQuestion: 2,
          viewModels: responseChoiceViewModelsSortedByOrder,
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
