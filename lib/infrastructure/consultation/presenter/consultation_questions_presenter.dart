import 'package:agora/bloc/consultation/question/consultation_questions_view_model.dart';
import 'package:agora/domain/consultation/questions/consultation_question.dart';
import 'package:agora/domain/consultation/questions/consultation_question_response_choice.dart';

class ConsultationQuestionsPresenter {
  static List<ConsultationQuestionViewModel> present(List<ConsultationQuestion> consultationQuestions) {
    final viewModels = consultationQuestions.map(
      (consultationQuestion) {
        if (consultationQuestion is ConsultationQuestionUnique) {
          return ConsultationQuestionUniqueViewModel(
            id: consultationQuestion.id,
            title: consultationQuestion.title,
            order: consultationQuestion.order,
            questionProgress: consultationQuestion.questionProgress,
            responseChoicesViewModels: _buildResponseChoices(consultationQuestion.responseChoices),
          );
        } else if (consultationQuestion is ConsultationQuestionMultiple) {
          return ConsultationQuestionMultipleViewModel(
            id: consultationQuestion.id,
            title: consultationQuestion.title,
            order: consultationQuestion.order,
            questionProgress: consultationQuestion.questionProgress,
            maxChoices: consultationQuestion.maxChoices,
            responseChoicesViewModels: _buildResponseChoices(consultationQuestion.responseChoices),
          );
        } else if (consultationQuestion is ConsultationQuestionOpened) {
          return ConsultationQuestionOpenedViewModel(
            id: consultationQuestion.id,
            title: consultationQuestion.title,
            order: consultationQuestion.order,
            questionProgress: consultationQuestion.questionProgress,
          );
        } else if (consultationQuestion is ConsultationQuestionChapter) {
          return ConsultationQuestionChapterViewModel(
            id: consultationQuestion.id,
            title: consultationQuestion.title,
            order: consultationQuestion.order,
            description: consultationQuestion.description,
          );
        } else {
          throw Exception(
            "ConsultationQuestionsPresenter : convert failed, type ${consultationQuestion.runtimeType} not handle",
          );
        }
      },
    ).toList()
      ..sort((viewModel1, viewModel2) => viewModel1.order.compareTo(viewModel2.order));

    return viewModels;
  }

  static int getFirstQuestionIndex(List<ConsultationQuestionViewModel> viewModels) {
    try {
      final firstQuestion = viewModels.firstWhere((viewModel) => viewModel is! ConsultationQuestionChapterViewModel);
      return viewModels.indexOf(firstQuestion);
    } catch (e) {
      return -1;
    }
  }

  static List<ConsultationQuestionResponseChoiceViewModel> _buildResponseChoices(
    List<ConsultationQuestionResponseChoice> responseChoices,
  ) {
    return responseChoices
        .map(
          (responseChoice) => ConsultationQuestionResponseChoiceViewModel(
            id: responseChoice.id,
            label: responseChoice.label,
            order: responseChoice.order,
          ),
        )
        .toList()
      ..sort((viewModel1, viewModel2) => viewModel1.order.compareTo(viewModel2.order));
  }
}
