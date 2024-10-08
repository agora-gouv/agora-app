part of 'app_feedback_page.dart';

class _Step2Screen extends StatelessWidget {
  final AppFeedbackType type;
  final String title;
  final String subTitle;
  final String hint;
  final String contentDescription;
  final void Function() onPrevious;

  _Step2Screen({
    required this.type,
    required this.title,
    required this.subTitle,
    required this.hint,
    required this.contentDescription,
    required this.onPrevious,
  });

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AgoraToolbar(style: AgoraToolbarStyle.close, semanticPageLabel: 'Formulaire de retour sur l\'application'),
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
                        currentQuestionIndex: 2,
                        totalQuestions: 2,
                      ),
                      SizedBox(height: AgoraSpacings.x0_75),
                      Text(
                        'Question 2/2',
                        style: AgoraTextStyles.medium16,
                        semanticsLabel: 'Question 2 sur 2',
                      ),
                      SizedBox(height: AgoraSpacings.base),
                      Padding(
                        padding: const EdgeInsets.only(bottom: AgoraSpacings.textAlignment),
                        child: Text(
                          title,
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
                          Text(subTitle, style: AgoraTextStyles.medium14),
                          SizedBox(height: AgoraSpacings.base),
                          AgoraTextField(
                            hintText: hint,
                            controller: controller,
                            contentDescription: contentDescription,
                            showCounterText: true,
                            blockToMaxLength: false,
                            maxLength: 1000,
                            minLines: 7,
                          ),
                          SizedBox(height: AgoraSpacings.base),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              AgoraButton.withLabel(
                                label: ConsultationStrings.previousQuestion,
                                semanticLabel: SemanticsStrings.previousQuestion,
                                buttonStyle: AgoraButtonStyle.secondary,
                                onPressed: onPrevious,
                              ),
                              const SizedBox(width: AgoraSpacings.base),
                              AgoraButton.withLabel(
                                label: ConsultationStrings.validate,
                                semanticLabel: ConsultationStrings.validate,
                                buttonStyle: AgoraButtonStyle.primary,
                                onPressed: () {
                                  context.read<AppFeedbackBloc>().add(
                                        SendAppFeedbackEvent(
                                          AppFeedback(
                                            type: type,
                                            description: controller.text,
                                          ),
                                        ),
                                      );
                                },
                              ),
                            ],
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

class _MailQuestionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AgoraToolbar(style: AgoraToolbarStyle.close, semanticPageLabel: 'Formulaire de retour sur l\'application'),
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
                        currentQuestionIndex: 2,
                        totalQuestions: 2,
                      ),
                      SizedBox(height: AgoraSpacings.x0_75),
                      Text(
                        'Question 2/2',
                        style: AgoraTextStyles.medium16,
                        semanticsLabel: 'Question 2 sur 2',
                      ),
                      SizedBox(height: AgoraSpacings.base),
                      Padding(
                        padding: const EdgeInsets.only(bottom: AgoraSpacings.textAlignment),
                        child: Text(
                          FeedbackStrings.mailTitle,
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
                          Text(FeedbackStrings.mailSubTitle, style: AgoraTextStyles.medium14),
                          SizedBox(height: AgoraSpacings.x3),
                          AgoraButton.withLabel(
                            label: FeedbackStrings.mailHint,
                            semanticLabel: FeedbackStrings.mailHint,
                            buttonStyle: AgoraButtonStyle.primary,
                            onPressed: () {
                              LaunchUrlHelper.mailtoAgora('Je souhaite participer à un atelier utilisateur');
                            },
                          ),
                          SizedBox(height: AgoraSpacings.base),
                          AgoraButton.withLabel(
                            label: FeedbackStrings.mailButtonLabel,
                            semanticLabel: FeedbackStrings.mailButtonLabel,
                            buttonStyle: AgoraButtonStyle.secondary,
                            onPressed: () {
                              context.read<AppFeedbackBloc>().add(AppFeedbackMailSentEvent());
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
