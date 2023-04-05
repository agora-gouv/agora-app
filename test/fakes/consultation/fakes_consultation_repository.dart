import 'package:agora/domain/consultation/details/consultation_details.dart';
import 'package:agora/domain/consultation/questions/consultation_question.dart';
import 'package:agora/domain/consultation/questions/consultation_question_response_choice.dart';
import 'package:agora/domain/consultation/questions/consultation_question_type.dart';
import 'package:agora/infrastructure/consultation/consultation_repository.dart';

class FakeConsultationSuccessRepository extends ConsultationRepository {
  @override
  Future<GetConsultationDetailsRepositoryResponse> fetchConsultationDetails({
    required String consultationId,
  }) async {
    return GetConsultationDetailsSucceedResponse(
      consultationDetails: ConsultationDetails(
        id: "consultationId",
        title: "Développer le covoiturage au quotidien",
        cover: "imageEnBase64",
        thematiqueId: "7",
        endDate: DateTime(2023, 3, 3),
        questionCount: "5 à 10 questions",
        estimatedTime: "5 minutes",
        participantCount: 15035,
        participantCountGoal: 30000,
        description: "<body>La description avec textes <b>en gras</b></body>",
        tipsDescription: "<body>texte <i>riche</i></body>",
      ),
    );
  }

  @override
  Future<GetConsultationQuestionsRepositoryResponse> fetchConsultationQuestions({
    required String consultationId,
  }) async {
    return GetConsultationQuestionsSucceedResponse(
      consultationQuestions: [
        ConsultationQuestion(
          id: "questionIdB",
          label: "Si vous vous lancez dans le co-voiturage, ...",
          order: 2,
          type: ConsultationQuestionType.unique,
          responseChoices: [
            ConsultationQuestionResponseChoice(id: "choiceAA", label: "non", order: 2),
            ConsultationQuestionResponseChoice(id: "choiceBB", label: "oui", order: 1),
          ],
        ),
        ConsultationQuestion(
          id: "questionIdA",
          label: "Comment vous rendez-vous généralement sur votre lieu de travail ?",
          order: 1,
          type: ConsultationQuestionType.unique,
          responseChoices: [
            ConsultationQuestionResponseChoice(id: "choiceA", label: "En vélo ou à pied", order: 1),
            ConsultationQuestionResponseChoice(id: "choiceC", label: "En transports en commun", order: 2),
          ],
        ),
      ],
    );
  }
}

class FakeConsultationFailureRepository extends ConsultationRepository {
  @override
  Future<GetConsultationDetailsRepositoryResponse> fetchConsultationDetails({
    required String consultationId,
  }) async {
    return GetConsultationDetailsFailedResponse();
  }

  @override
  Future<GetConsultationQuestionsRepositoryResponse> fetchConsultationQuestions({
    required String consultationId,
  }) async {
    return GetConsultationQuestionsFailedResponse();
  }
}
