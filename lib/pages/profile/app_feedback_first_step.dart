part of 'app_feedback_page.dart';

class _FirstStepScreen extends StatefulWidget {
  final void Function(_AppFeedbackChoice) onTypeChosed;

  _FirstStepScreen({required this.onTypeChosed});

  @override
  State<_FirstStepScreen> createState() => _FirstStepScreenState();
}

class _FirstStepScreenState extends State<_FirstStepScreen> {
  _AppFeedbackChoice? choice;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AgoraToolbar(style: AgoraToolbarStyle.close, pageLabel: 'Formulaire de retour sur l\'application'),
        Expanded(
          child: AgoraSingleScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AgoraQuestionsProgressBar(
                        currentQuestionOrder: 1,
                        totalQuestions: 2,
                      ),
                      SizedBox(height: AgoraSpacings.x0_75),
                      Text(
                        'Question 1/2',
                        style: AgoraTextStyles.medium16,
                        semanticsLabel: 'Question 1 sur 2',
                      ),
                      SizedBox(height: AgoraSpacings.base),
                      Padding(
                        padding: const EdgeInsets.only(bottom: AgoraSpacings.textAlignment),
                        child: Text(
                          'Quel retour souhaitez-vous faire ? ',
                          style: AgoraTextStyles.medium20.copyWith(color: AgoraColors.primaryBlue),
                        ),
                      ),
                      SizedBox(height: AgoraSpacings.x0_5),
                    ],
                  ),
                ),
                Flexible(
                  child: Container(
                    width: double.infinity,
                    color: AgoraColors.background,
                    child: Padding(
                      padding: const EdgeInsets.all(AgoraSpacings.horizontalPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AgoraQuestionResponseChoiceView(
                            responseId: 'id',
                            responseLabel: 'J’ai remarqué un bug, quelque chose qui ne semble pas fonctionner correctement',
                            hasOpenTextField: false,
                            isSelected: choice == _AppFeedbackChoice.bug,
                            previousOtherResponse: '',
                            semantic: AgoraQuestionResponseChoiceSemantic(currentIndex: 1, totalIndex: 4),
                            onTap: (responseId) {
                              setState(() => choice = _AppFeedbackChoice.bug);
                            },
                            onOtherResponseChanged: (_, __) {},
                          ),
                          SizedBox(height: AgoraSpacings.base),
                          AgoraQuestionResponseChoiceView(
                            responseId: 'id',
                            responseLabel: 'J’ai une idée d’amélioration ou de nouvelle fonctionnalité',
                            hasOpenTextField: false,
                            isSelected: choice == _AppFeedbackChoice.feature,
                            previousOtherResponse: '',
                            semantic: AgoraQuestionResponseChoiceSemantic(currentIndex: 2, totalIndex: 4),
                            onTap: (responseId) {
                              setState(() => choice = _AppFeedbackChoice.feature);
                            },
                            onOtherResponseChanged: (_, __) {},
                          ),
                          SizedBox(height: AgoraSpacings.base),
                          AgoraQuestionResponseChoiceView(
                            responseId: 'id',
                            responseLabel: 'J’ai un commentaire, des critiques à faire sur l’application en général ',
                            hasOpenTextField: false,
                            isSelected: choice == _AppFeedbackChoice.comment,
                            previousOtherResponse: '',
                            semantic: AgoraQuestionResponseChoiceSemantic(currentIndex: 3, totalIndex: 4),
                            onTap: (responseId) {
                              setState(() => choice = _AppFeedbackChoice.comment);
                            },
                            onOtherResponseChanged: (_, __) {},
                          ),
                          SizedBox(height: AgoraSpacings.base),
                          AgoraQuestionResponseChoiceView(
                            responseId: 'id',
                            responseLabel: 'J’aimerais participer à un atelier utilisateur ',
                            hasOpenTextField: false,
                            isSelected: choice == _AppFeedbackChoice.mail,
                            previousOtherResponse: '',
                            semantic: AgoraQuestionResponseChoiceSemantic(currentIndex: 4, totalIndex: 4),
                            onTap: (responseId) {
                              setState(() => choice = _AppFeedbackChoice.mail);
                            },
                            onOtherResponseChanged: (_, __) {},
                          ),
                          SizedBox(height: AgoraSpacings.base),
                          if (choice != null)
                            AgoraButton(
                              label: ConsultationStrings.nextQuestion,
                              semanticLabel: SemanticsStrings.nextQuestion,
                              style: AgoraButtonStyle.primaryButtonStyle,
                              onPressed: () {
                                widget.onTypeChosed(choice!);
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}