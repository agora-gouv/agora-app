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
      questionProgressSemanticLabel: "Question 1 sur 4",
      maxChoices: 2,
      responseChoicesViewModels: [
        ConsultationQuestionResponseChoiceViewModel(
          id: "choiceB",
          label: "En voiture",
          order: 1,
          hasOpenTextField: false,
        ),
        ConsultationQuestionResponseChoiceViewModel(
          id: "choiceC",
          label: "En transports en commun",
          order: 2,
          hasOpenTextField: false,
        ),
        ConsultationQuestionResponseChoiceViewModel(
          id: "choiceA",
          label: "En vélo ou à pied",
          order: 3,
          hasOpenTextField: false,
        ),
        ConsultationQuestionResponseChoiceViewModel(
          id: "choiceD",
          label: "Autre (précisez)",
          order: 4,
          hasOpenTextField: true,
        ),
      ],
      nextQuestionId: "questionIdD",
      popupDescription: "<body>La description avec textes <b>en gras</b></body>",
    ),
    ConsultationQuestionWithConditionViewModel(
      id: "questionIdD",
      title: "Avez vous ...?",
      order: 2,
      questionProgress: "Question 2/4",
      questionProgressSemanticLabel: "Question 2 sur 4",
      responseChoicesViewModels: [
        ConsultationQuestionWithConditionResponseChoiceViewModel(
          id: "choiceBBB",
          label: "oui",
          order: 1,
          nextQuestionId: "questionIdC",
          hasOpenTextField: false,
        ),
        ConsultationQuestionWithConditionResponseChoiceViewModel(
          id: "choiceAAA",
          label: "non",
          order: 2,
          nextQuestionId: "questionIdB",
          hasOpenTextField: false,
        ),
        ConsultationQuestionWithConditionResponseChoiceViewModel(
          id: "choiceCCC",
          label: "Autre (précisez)",
          order: 3,
          nextQuestionId: "questionIdB",
          hasOpenTextField: true,
        ),
      ],
      popupDescription: "<body>La description avec textes <b>en gras</b></body>",
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
      questionProgressSemanticLabel: "Question 3 sur 4",
      responseChoicesViewModels: [
        ConsultationQuestionResponseChoiceViewModel(id: "choiceBB", label: "oui", order: 1, hasOpenTextField: false),
        ConsultationQuestionResponseChoiceViewModel(id: "choiceAA", label: "non", order: 2, hasOpenTextField: false),
        ConsultationQuestionResponseChoiceViewModel(
          id: "choiceCC",
          label: "Autre (précisez)",
          order: 3,
          hasOpenTextField: true,
        ),
      ],
      nextQuestionId: "questionIdC",
      popupDescription: "<body>La description avec textes <b>en gras</b></body>",
    ),
    ConsultationQuestionOpenedViewModel(
      id: "questionIdC",
      title: "Question C ?",
      order: 5,
      questionProgress: "Question 4/4",
      questionProgressSemanticLabel: "Question 4 sur 4",
      nextQuestionId: null,
      popupDescription: null,
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
