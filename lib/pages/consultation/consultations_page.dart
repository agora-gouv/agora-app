import 'package:agora/bloc/consultation/consultation_bloc.dart';
import 'package:agora/bloc/consultation/consultation_event.dart';
import 'package:agora/bloc/consultation/consultation_state.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_main_toolbar.dart';
import 'package:agora/design/custom_view/agora_rich_text.dart';
import 'package:agora/design/custom_view/agora_tracker.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/domain/consultation/consultations_error_type.dart';
import 'package:agora/pages/consultation/consultations_answered_section.dart';
import 'package:agora/pages/consultation/consultations_finished_section.dart';
import 'package:agora/pages/consultation/consultations_loading_skeleton.dart';
import 'package:agora/pages/consultation/consultations_ongoing_section.dart';
import 'package:agora/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsultationsPage extends StatefulWidget {
  static const routeName = "/consultationsPage";

  @override
  State<ConsultationsPage> createState() => _ConsultationsPageState();
}

class _ConsultationsPageState extends State<ConsultationsPage> {
  final GlobalKey toolbarTitleKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      toolbarTitleKey.currentContext?.findRenderObject()?.sendSemanticsEvent(FocusSemanticEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return AgoraTracker(
      widgetName: AnalyticsScreenNames.consultationsPage,
      child: BlocProvider(
        create: (BuildContext context) {
          return ConsultationBloc(
            consultationRepository: RepositoryManager.getConsultationRepository(),
          )..add(FetchConsultationsEvent());
        },
        child: BlocBuilder<ConsultationBloc, ConsultationState>(
          builder: (context, state) {
            return SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  AgoraMainToolbar(
                    title: AgoraRichText(
                      key: toolbarTitleKey,
                      policeStyle: AgoraRichTextPoliceStyle.toolbar,
                      semantic: AgoraRichTextSemantic(focused: true),
                      items: [
                        AgoraRichTextItem(
                          text: "${ConsultationStrings.toolbarPart1}\n",
                          style: AgoraRichTextItemStyle.regular,
                        ),
                        AgoraRichTextItem(
                          text: ConsultationStrings.toolbarPart2,
                          style: AgoraRichTextItemStyle.bold,
                        ),
                      ],
                    ),
                    onProfileClick: () => Navigator.pushNamed(context, ProfilePage.routeName),
                  ),
                  Column(children: _handleConsultationsState(context, state)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _handleConsultationsState(BuildContext context, ConsultationState state) {
    if (state is ConsultationsFetchedState) {
      return [
        ConsultationsOngoingSection(
          ongoingViewModels: state.ongoingViewModels,
          answeredSectionEmpty: state.answeredViewModels.isEmpty,
        ),
        ConsultationsFinishedSection(
          finishedViewModels: state.finishedViewModels,
          shouldDisplayAllButton: state.shouldDisplayFinishedAllButton,
        ),
        ConsultationsAnsweredSection(answeredViewModels: state.answeredViewModels),
        _SuccessFooter(),
      ];
    } else if (state is ConsultationInitialLoadingState) {
      return [ConsultationsLoadingSkeleton()];
    } else if (state is ConsultationErrorState && state.errorType == ConsultationsErrorType.timeout) {
      return _buildPadding(
        context,
        AgoraErrorView(errorMessage: GenericStrings.timeoutErrorMessage, textAlign: TextAlign.center),
      );
    } else if (state is ConsultationErrorState && state.errorType == ConsultationsErrorType.generic) {
      return _buildPadding(context, AgoraErrorView());
    }
    return [];
  }

  List<Widget> _buildPadding(BuildContext context, Widget child) {
    return [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 10 * 3),
            Center(child: child),
            SizedBox(height: AgoraSpacings.x2),
          ],
        ),
      ),
    ];
  }
}

class _SuccessFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AgoraSpacings.horizontalPadding),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('🤝', style: AgoraTextStyles.regular26),
          const SizedBox(width: AgoraSpacings.base),
          Expanded(
            child: AgoraRichText(
              policeStyle: AgoraRichTextPoliceStyle.police16Interligne140,
              items: [
                AgoraRichTextItem(
                  text: "Agora",
                  style: AgoraRichTextItemStyle.primaryBold,
                ),
                AgoraRichTextItem(
                  text: ', l’application qui vous donne la parole et vous rend des comptes !',
                  style: AgoraRichTextItemStyle.regular,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
