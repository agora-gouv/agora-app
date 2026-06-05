import 'package:agora/common/parser/string_parser.dart';
import 'package:agora/consultation/bloc/consultation_questions_state.dart';
import 'package:agora/consultation/question/bloc/consultation_questions_bloc.dart';
import 'package:agora/consultation/question/bloc/consultation_questions_event.dart';
import 'package:agora/consultation/question/bloc/consultation_questions_view_model.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/consultation/fakes_consultation_repository.dart';

void main() {
  const consultationId = "consultationId";

  final responseChoiceViewModelsSortedByOrder = [
    ConsultationQuestionMultipleViewModel(
      id: "questionIdA",
      title: [StringSegment("Comment vous rendez-vous généralement sur votre lieu de travail ?", false)],
      order: 1,
      maxChoices: 2,
      responseChoicesViewModels: [
        ConsultationQuestionResponseChoiceViewModel(
          id: "choiceB",
          label: [StringSegment("En voiture ", false), StringSegment("🚗", true)],
          order: 1,
          hasOpenTextField: false,
        ),
        ConsultationQuestionResponseChoiceViewModel(
          id: "choiceC",
          label: [StringSegment("En transports en commun ", false), StringSegment("🚃", true)],
          order: 2,
          hasOpenTextField: false,
        ),
        ConsultationQuestionResponseChoiceViewModel(
          id: "choiceA",
          label: [StringSegment("En vélo ou à pied ", false), StringSegment("🚲", true)],
          order: 3,
          hasOpenTextField: false,
        ),
        ConsultationQuestionResponseChoiceViewModel(
          id: "choiceD",
          label: [StringSegment("Autre (précisez)", false)],
          order: 4,
          hasOpenTextField: true,
        ),
      ],
      nextQuestionId: "questionIdD",
      popupDescription: "<body>La description avec textes <b>en gras</b></body>",
    ),
    ConsultationQuestionWithConditionViewModel(
      id: "questionIdD",
      title: [StringSegment("Avez vous ...?", false)],
      order: 2,
      responseChoicesViewModels: [
        ConsultationQuestionWithConditionResponseChoiceViewModel(
          id: "choiceBBB",
          label: [StringSegment("oui", false)],
          order: 1,
          nextQuestionId: "questionIdC",
          hasOpenTextField: false,
        ),
        ConsultationQuestionWithConditionResponseChoiceViewModel(
          id: "choiceAAA",
          label: [StringSegment("non", false)],
          order: 2,
          nextQuestionId: "questionIdB",
          hasOpenTextField: false,
        ),
        ConsultationQuestionWithConditionResponseChoiceViewModel(
          id: "choiceCCC",
          label: [StringSegment("Autre (précisez)", false)],
          order: 3,
          nextQuestionId: "questionIdB",
          hasOpenTextField: true,
        ),
      ],
      popupDescription: "<body>La description avec textes <b>en gras</b></body>",
    ),
    ConsultationQuestionChapterViewModel(
      id: "chapiter1",
      title: [StringSegment("titre du chapitre", false)],
      order: 3,
      description: "description du chapitre",
      nextQuestionId: "questionIdB",
      imageUrl: "https://url.com/image.jpg",
      imageTranscription: "Cette image représente le Petit Cheval de Manège",
    ),
    ConsultationQuestionUniqueViewModel(
      id: "questionIdB",
      title: [StringSegment("Si vous vous lancez dans le co-voiturage, ...", false)],
      order: 4,
      responseChoicesViewModels: [
        ConsultationQuestionResponseChoiceViewModel(
          id: "choiceBB",
          label: [StringSegment("oui", false)],
          order: 1,
          hasOpenTextField: false,
        ),
        ConsultationQuestionResponseChoiceViewModel(
          id: "choiceAA",
          label: [StringSegment("non", false)],
          order: 2,
          hasOpenTextField: false,
        ),
        ConsultationQuestionResponseChoiceViewModel(
          id: "choiceCC",
          label: [StringSegment("Autre (précisez)", false)],
          order: 3,
          hasOpenTextField: true,
        ),
      ],
      nextQuestionId: "questionIdC",
      popupDescription: "<body>La description avec textes <b>en gras</b></body>",
    ),
    ConsultationQuestionOpenedViewModel(
      id: "questionIdC",
      title: [StringSegment("Question C ?", false)],
      order: 5,
      nextQuestionId: null,
      popupDescription: null,
    ),
  ];

  final consultationQuestionsViewModel = ConsultationQuestionsViewModel(
    questionCount: 5,
    questions: responseChoiceViewModelsSortedByOrder,
  );

  group("FetchConsultationQuestionsEvent", () {
    blocTest(
      "when repository succeed - should emit success state",
      build: () => ConsultationQuestionsBloc(
        consultationRepository: FakeConsultationSuccessRepository(),
      ),
      act: (bloc) => bloc.add(FetchConsultationQuestionsEvent(consultationId: consultationId)),
      expect: () => [
        ConsultationQuestionsFetchedState(consultationQuestionsViewModel: consultationQuestionsViewModel),
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
