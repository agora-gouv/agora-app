import 'package:agora/bloc/consultation/question/consultation_questions_view_model.dart';
import 'package:agora/domain/consultation/questions/consultation_question.dart';
import 'package:agora/domain/consultation/questions/consultation_question_response_choice.dart';
import 'package:agora/domain/consultation/questions/consultation_questions.dart';
import 'package:agora/pages/consultation/dynamic/string_parser.dart';

class ConsultationQuestionsPresenter {
  static ConsultationQuestionsViewModel present(ConsultationQuestions consultationQuestions) {
    final viewModels = consultationQuestions.questions.map(
      (consultationQuestion) {
        if (consultationQuestion is ConsultationQuestionUnique) {
          return ConsultationQuestionUniqueViewModel(
            id: consultationQuestion.id,
            title: StringParser.splitByEmoji(consultationQuestion.title),
            order: consultationQuestion.order,
            responseChoicesViewModels: _buildResponseChoices(consultationQuestion.responseChoices),
            nextQuestionId: consultationQuestion.nextQuestionId,
            popupDescription: consultationQuestion.popupDescription,
          );
        } else if (consultationQuestion is ConsultationQuestionMultiple) {
          return ConsultationQuestionMultipleViewModel(
            id: consultationQuestion.id,
            title: StringParser.splitByEmoji(consultationQuestion.title),
            order: consultationQuestion.order,
            maxChoices: consultationQuestion.maxChoices,
            responseChoicesViewModels: _buildResponseChoices(consultationQuestion.responseChoices),
            nextQuestionId: consultationQuestion.nextQuestionId,
            popupDescription: consultationQuestion.popupDescription,
          );
        } else if (consultationQuestion is ConsultationQuestionOpened) {
          return ConsultationQuestionOpenedViewModel(
            id: consultationQuestion.id,
            title: StringParser.splitByEmoji(consultationQuestion.title),
            order: consultationQuestion.order,
            nextQuestionId: consultationQuestion.nextQuestionId,
            popupDescription: consultationQuestion.popupDescription,
          );
        } else if (consultationQuestion is ConsultationQuestionWithCondition) {
          return ConsultationQuestionWithConditionViewModel(
            id: consultationQuestion.id,
            title: StringParser.splitByEmoji(consultationQuestion.title),
            order: consultationQuestion.order,
            responseChoicesViewModels: _buildResponseWithConditionChoices(consultationQuestion.responseChoices),
            popupDescription: consultationQuestion.popupDescription,
          );
        } else if (consultationQuestion is ConsultationQuestionChapter) {
          return ConsultationQuestionChapterViewModel(
            id: consultationQuestion.id,
            title: StringParser.splitByEmoji(consultationQuestion.title),
            order: consultationQuestion.order,
            description: consultationQuestion.description,
            nextQuestionId: consultationQuestion.nextQuestionId,
          );
        } else {
          throw Exception(
            "ConsultationQuestionsPresenter : convert failed, type ${consultationQuestion.runtimeType} not handle",
          );
        }
      },
    ).toList()
      ..sort((viewModel1, viewModel2) => viewModel1.order.compareTo(viewModel2.order));
    return ConsultationQuestionsViewModel(questionCount: consultationQuestions.questionCount, questions: viewModels);
  }

  static List<ConsultationQuestionResponseChoiceViewModel> _buildResponseChoices(
    List<ConsultationQuestionResponseChoice> responseChoices,
  ) {
    return responseChoices
        .map(
          (responseChoice) => ConsultationQuestionResponseChoiceViewModel(
            id: responseChoice.id,
            label: StringParser.splitByEmoji(responseChoice.label),
            order: responseChoice.order,
            hasOpenTextField: responseChoice.hasOpenTextField,
          ),
        )
        .toList()
      ..sort((viewModel1, viewModel2) => viewModel1.order.compareTo(viewModel2.order));
  }

  static List<ConsultationQuestionWithConditionResponseChoiceViewModel> _buildResponseWithConditionChoices(
    List<ConsultationQuestionResponseWithConditionChoice> responseChoices,
  ) {
    return responseChoices
        .map(
          (responseChoice) => ConsultationQuestionWithConditionResponseChoiceViewModel(
            id: responseChoice.id,
            label: StringParser.splitByEmoji(responseChoice.label),
            order: responseChoice.order,
            nextQuestionId: responseChoice.nextQuestionId,
            hasOpenTextField: responseChoice.hasOpenTextField,
          ),
        )
        .toList()
      ..sort((viewModel1, viewModel2) => viewModel1.order.compareTo(viewModel2.order));
  }
}
