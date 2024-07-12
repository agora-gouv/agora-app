import 'package:agora/consultation/dynamic/bloc/dynamic_consultation_bloc.dart';
import 'package:agora/consultation/dynamic/bloc/dynamic_consultation_events.dart';
import 'package:agora/consultation/dynamic/bloc/dynamic_consultation_state.dart';
import 'package:agora/consultation/dynamic/domain/dynamic_consultation.dart';
import 'package:agora/consultation/dynamic/domain/dynamic_consultation_section.dart';
import 'package:bloc_test/bloc_test.dart';

import '../../fakes/consultation/fake_consultation_question_storage_client.dart';
import '../../fakes/consultation/fakes_consultation_repository.dart';

void main() {
  final consultation = DynamicConsultation(
    id: 'consultationId',
    title: 'Développer le covoiturage au quotidien',
    coverUrl: '<coverUrl>',
    shareText: 'A définir ¯\\_(ツ)_/¯',
    thematicLogo: '🚊',
    thematicLabel: 'Transports',
    questionsInfos: ConsultationQuestionsInfos(
      endDate: DateTime(2023, 12, 30),
      questionCount: '5 à 10 questions',
      estimatedTime: '5 minutes',
      participantCount: 15035,
      participantCountGoal: 30000,
    ),
    responseInfos: ConsultationResponseInfos(
      id: 'consultationId',
      picto: '🙌',
      description: '<body>Texte riche</body>',
      buttonLabel: 'Label du bouton',
    ),
    infoHeader: ConsultationInfoHeader(
      logo: "📘",
      description: "<body>Texte riche</body>",
    ),
    collapsedSections: [
      DynamicConsultationSectionTitle('Le titre de la section'),
    ],
    expandedSections: [
      DynamicConsultationSectionTitle('Le titre de la section'),
      DynamicConsultationSectionRichText("<body>Texte riche</body>"),
      DynamicConsultationSectionImage(
        desctiption: "Description textuelle de l'image",
        url: "<imageUrl>",
      ),
      DynamicConsultationSectionVideo(
        url: "<videoUrl>",
        transcription: 'Transcription video',
        width: 1080,
        height: 1920,
        authorName: 'Olivier Véran',
        authorDescription: 'Ministre de ...',
        date: DateTime(2023, 12, 30),
      ),
      DynamicConsultationSectionFocusNumber(
        title: '30%',
        desctiption: '<body>Texte riche</body>',
      ),
      DynamicConsultationSectionQuote('<body>Lorem ipsum... version riche</body>'),
    ],
    downloadInfo: ConsultationDownloadInfo(
      url: '<url>',
    ),
    participationInfo: ConsultationParticipationInfo(
      participantCountGoal: 30000,
      participantCount: 15035,
      shareText: 'A définir ¯\\_(ツ)_/¯',
    ),
    feedbackQuestion: ConsultationFeedbackQuestion(
      id: '<updateId>',
      title: 'Donner votre avis',
      picto: '💬',
      description: '<body>Texte riche</body>',
      userResponse: false,
    ),
    feedbackResult: ConsultationFeedbackResults(
      id: '<updateId>',
      title: 'Donner votre avis',
      picto: '💬',
      description: '<body>Texte riche</body>',
      userResponseIsPositive: true,
      positiveRatio: 68,
      negativeRatio: 32,
      responseCount: 14034,
    ),
    history: [
      ConsultationHistoryStep(
        updateId: "<updateId>",
        type: ConsultationHistoryStepType.update,
        status: ConsultationHistoryStepStatus.done,
        title: "Lancement",
        date: DateTime(2023, 12, 30),
        actionText: "Voir les objectifs",
      ),
    ],
    footer: ConsultationFooter(
      title: "Envie d'aller plus loin ?",
      description: "<body>Texte riche</body>",
    ),
    headerSections: [
      DynamicConsultationSectionFocusNumber(
        title: '30%',
        desctiption: '<body>Texte riche</body>',
      ),
    ],
    goals: [
      ConsultationGoal(
        picto: 'picto',
        description: 'description',
      ),
    ],
  );

  blocTest(
    "when repository succeed - should emit success state",
    build: () => DynamicConsultationBloc(
      FakeConsultationSuccessRepository(consultation),
      FakeConsultationQuestionStorageClient(),
    ),
    act: (bloc) => bloc.add(FetchDynamicConsultationEvent('id')),
    expect: () => [
      DynamicConsultationSuccessState(consultation),
    ],
  );

  blocTest(
    "when repository fails - should emit error state",
    build: () => DynamicConsultationBloc(
      FakeConsultationFailureRepository(),
      FakeConsultationQuestionStorageClient(),
    ),
    act: (bloc) => bloc.add(FetchDynamicConsultationEvent('id')),
    expect: () => [
      DynamicConsultationErrorState(),
    ],
  );
}
