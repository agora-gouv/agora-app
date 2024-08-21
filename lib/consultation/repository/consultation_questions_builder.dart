import 'package:agora/consultation/question/domain/consultation_question.dart';
import 'package:agora/consultation/question/domain/consultation_question_response_choice.dart';

class ConsultationQuestionsBuilder {
  static List<ConsultationQuestion> buildQuestions({
    required List<dynamic> uniqueChoiceQuestions,
    required List<dynamic> openedQuestions,
    required List<dynamic> multipleChoicesQuestions,
    required List<dynamic> withConditionQuestions,
    required List<dynamic> chapters,
  }) {
    return _buildUniqueChoiceQuestions(uniqueChoiceQuestions) +
        _buildOpenedQuestions(openedQuestions) +
        _buildMultipleChoicesQuestions(multipleChoicesQuestions) +
        _buildWithConditionsQuestions(withConditionQuestions) +
        _buildChapters(chapters);
  }

  static List<ConsultationQuestion> _buildUniqueChoiceQuestions(List<dynamic> questionsUniqueChoice) {
    final List<ConsultationQuestion> questions = [];
    for (final questionUniqueChoice in questionsUniqueChoice) {
      questions.add(
        ConsultationQuestionUnique(
          id: questionUniqueChoice["id"] as String,
          title: questionUniqueChoice["title"] as String,
          order: questionUniqueChoice["order"] as int,
          responseChoices: (questionUniqueChoice["possibleChoices"] as List)
              .map(
                (responseChoice) => ConsultationQuestionResponseChoice(
                  id: responseChoice["id"] as String,
                  label: responseChoice["label"] as String,
                  order: responseChoice["order"] as int,
                  hasOpenTextField: responseChoice["hasOpenTextField"] as bool,
                ),
              )
              .toList(),
          nextQuestionId: questionUniqueChoice["nextQuestionId"] as String?,
          popupDescription: questionUniqueChoice["popupDescription"] as String?,
        ),
      );
    }
    return questions;
  }

  static List<ConsultationQuestion> _buildOpenedQuestions(List<dynamic> questionsOpened) {
    final List<ConsultationQuestion> questions = [];
    for (final questionOpened in questionsOpened) {
      questions.add(
        ConsultationQuestionOpened(
          id: questionOpened["id"] as String,
          title: questionOpened["title"] as String,
          order: questionOpened["order"] as int,
          nextQuestionId: questionOpened["nextQuestionId"] as String?,
          popupDescription: questionOpened["popupDescription"] as String?,
        ),
      );
    }
    return questions;
  }

  static List<ConsultationQuestion> _buildMultipleChoicesQuestions(List<dynamic> questionsMultipleChoices) {
    final List<ConsultationQuestion> questions = [];
    for (final questionMultipleChoices in questionsMultipleChoices) {
      questions.add(
        ConsultationQuestionMultiple(
          id: questionMultipleChoices["id"] as String,
          title: questionMultipleChoices["title"] as String,
          order: questionMultipleChoices["order"] as int,
          maxChoices: questionMultipleChoices["maxChoices"] as int,
          responseChoices: (questionMultipleChoices["possibleChoices"] as List)
              .map(
                (responseChoice) => ConsultationQuestionResponseChoice(
                  id: responseChoice["id"] as String,
                  label: responseChoice["label"] as String,
                  order: responseChoice["order"] as int,
                  hasOpenTextField: responseChoice["hasOpenTextField"] as bool,
                ),
              )
              .toList(),
          nextQuestionId: questionMultipleChoices["nextQuestionId"] as String?,
          popupDescription: questionMultipleChoices["popupDescription"] as String?,
        ),
      );
    }
    return questions;
  }

  static List<ConsultationQuestion> _buildWithConditionsQuestions(List<dynamic> withConditionQuestions) {
    final List<ConsultationQuestion> questions = [];
    for (final withConditionQuestion in withConditionQuestions) {
      questions.add(
        ConsultationQuestionWithCondition(
          id: withConditionQuestion["id"] as String,
          title: withConditionQuestion["title"] as String,
          order: withConditionQuestion["order"] as int,
          responseChoices: (withConditionQuestion["possibleChoices"] as List)
              .map(
                (responseChoice) => ConsultationQuestionResponseWithConditionChoice(
                  id: responseChoice["id"] as String,
                  label: responseChoice["label"] as String,
                  order: responseChoice["order"] as int,
                  nextQuestionId: responseChoice["nextQuestionId"] as String,
                  hasOpenTextField: responseChoice["hasOpenTextField"] as bool,
                ),
              )
              .toList(),
          popupDescription: withConditionQuestion["popupDescription"] as String?,
        ),
      );
    }
    return questions;
  }

  static List<ConsultationQuestion> _buildChapters(List<dynamic> chapters) {
    final List<ConsultationQuestion> questions = [];
    for (final chapter in chapters) {
      questions.add(
        ConsultationQuestionChapter(
          id: chapter["id"] as String,
          title: chapter["title"] as String,
          order: chapter["order"] as int,
          description: chapter["description"] as String,
          nextQuestionId: chapter["nextQuestionId"] as String?,
        ),
      );
    }
    return questions;
  }
}
