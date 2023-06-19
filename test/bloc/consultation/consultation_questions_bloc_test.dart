import 'package:agora/bloc/consultation/question/consultation_questions_bloc.dart';
import 'package:agora/bloc/consultation/question/consultation_questions_event.dart';
import 'package:agora/bloc/consultation/question/consultation_questions_state.dart';
import 'package:agora/bloc/consultation/question/consultation_questions_view_model.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/consultation/fakes_consultation_repository.dart';

void main() {
  const consultationId = "consultationId";

  final responseChoiceViewModelsSortedByOrder = [
    ConsultationQuestionMultipleViewModel(
      id: "questionIdA",
      title: "Comment vous rendez-vous généralement sur votre lieu de travail ?",
      order: 1,
      questionProgress: "Question 1/4",
      maxChoices: 2,
      responseChoicesViewModels: [
        ConsultationQuestionResponseChoiceViewModel(id: "choiceB", label: "En voiture", order: 1),
        ConsultationQuestionResponseChoiceViewModel(id: "choiceC", label: "En transports en commun", order: 2),
        ConsultationQuestionResponseChoiceViewModel(id: "choiceA", label: "En vélo ou à pied", order: 3),
      ],
      nextQuestionId: "questionIdD",
    ),
    ConsultationQuestionWithConditionViewModel(
      id: "questionIdD",
      title: "Avez vous ...?",
      order: 2,
      questionProgress: "Question 2/4",
      responseChoicesViewModels: [
        ConsultationQuestionWithConditionResponseChoiceViewModel(
          id: "choiceBBB",
          label: "oui",
          order: 1,
          nextQuestionId: "questionIdC",
        ),
        ConsultationQuestionWithConditionResponseChoiceViewModel(
          id: "choiceAAA",
          label: "non",
          order: 2,
          nextQuestionId: "questionIdB",
        ),
      ],
    ),
    ConsultationQuestionChapterViewModel(
      id: "chapiter1",
      title: "titre du chapitre",
      order: 3,
      description: "description du chapitre",
      nextQuestionId: "questionIdB",
    ),
    ConsultationQuestionUniqueViewModel(
      id: "questionIdB",
      title: "Si vous vous lancez dans le co-voiturage, ...",
      order: 4,
      questionProgress: "Question 3/4",
      responseChoicesViewModels: [
        ConsultationQuestionResponseChoiceViewModel(id: "choiceBB", label: "oui", order: 1),
        ConsultationQuestionResponseChoiceViewModel(id: "choiceAA", label: "non", order: 2),
      ],
      nextQuestionId: "questionIdC",
    ),
    ConsultationQuestionOpenedViewModel(
      id: "questionIdC",
      title: "Question C ?",
      order: 5,
      questionProgress: "Question 4/4",
      nextQuestionId: null,
    ),
  ];

  group("FetchConsultationQuestionsEvent", () {
    blocTest(
      "when repository succeed - should emit success state",
      build: () => ConsultationQuestionsBloc(
        consultationRepository: FakeConsultationSuccessRepository(),
      ),
      act: (bloc) => bloc.add(FetchConsultationQuestionsEvent(consultationId: consultationId)),
      expect: () => [
        ConsultationQuestionsFetchedState(viewModels: responseChoiceViewModelsSortedByOrder),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed - should emit failure state",
      build: () => ConsultationQuestionsBloc(
        consultationRepository: FakeConsultationFailureRepository(),
      ),
      act: (bloc) => bloc.add(FetchConsultationQuestionsEvent(consultationId: consultationId)),
      expect: () => [
        ConsultationQuestionsErrorState(),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
