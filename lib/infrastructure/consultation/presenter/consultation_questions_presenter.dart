import 'package:agora/bloc/consultation/question/consultation_questions_view_model.dart';
import 'package:agora/domain/consultation/questions/consultation_question.dart';
import 'package:agora/domain/consultation/questions/consultation_question_response_choice.dart';

class ConsultationQuestionsPresenter {
  static List<ConsultationQuestionViewModel> present(List<ConsultationQuestion> consultationQuestions) {
    final viewModels = consultationQuestions
        .map(
          (consultationQuestion) => ConsultationQuestionViewModel(
            id: consultationQuestion.id,
            label: consultationQuestion.label,
            order: consultationQuestion.order,
            type: consultationQuestion.type,
            maxChoices: consultationQuestion.maxChoices,
            responseChoicesViewModels: _buildResponseChoices(consultationQuestion.responseChoices),
          ),
        )
        .toList()
      ..sort((viewModel1, viewModel2) => viewModel1.order.compareTo(viewModel2.order));

    return viewModels;
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
