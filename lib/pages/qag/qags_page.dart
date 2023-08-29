import 'package:agora/bloc/qag/qag_bloc.dart';
import 'package:agora/bloc/qag/qag_event.dart';
import 'package:agora/bloc/qag/qag_state.dart';
import 'package:agora/bloc/qag/support/qag_support_bloc.dart';
import 'package:agora/bloc/thematique/thematique_bloc.dart';
import 'package:agora/bloc/thematique/thematique_event.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_main_toolbar.dart';
import 'package:agora/design/custom_view/agora_rich_text.dart';
import 'package:agora/design/custom_view/agora_tracker.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/domain/qag/qags_error_type.dart';
import 'package:agora/pages/profile/profile_page.dart';
import 'package:agora/pages/qag/qags_ask_question_section.dart';
import 'package:agora/pages/qag/qags_response_section.dart';
import 'package:agora/pages/qag/qags_section.dart';
import 'package:agora/pages/qag/qags_thematique_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagsPage extends StatefulWidget {
  static const routeName = "/qagsPage";

  @override
  State<QagsPage> createState() => _QagsPageState();
}

class _QagsPageState extends State<QagsPage> {
  final GlobalKey toolbarTitleKey = GlobalKey();
  String? currentThematiqueId;

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
      widgetName: AnalyticsScreenNames.qagsPage,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => QagBloc(
              qagRepository: RepositoryManager.getQagRepository(),
            )..add(FetchQagsEvent(thematiqueId: currentThematiqueId)),
          ),
          BlocProvider(
            create: (BuildContext context) => QagSupportBloc(qagRepository: RepositoryManager.getQagRepository()),
          ),
          BlocProvider(
            create: (context) => ThematiqueBloc(
              repository: RepositoryManager.getThematiqueRepository(),
            )..add(FetchFilterThematiqueEvent()),
          ),
        ],
        child: BlocBuilder<QagBloc, QagState>(
          builder: (context, state) {
            return SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  AgoraMainToolbar(
                    title: AgoraRichText(
                      key: toolbarTitleKey,
                      policeStyle: AgoraRichTextPoliceStyle.toolbar,
                      items: [
                        AgoraRichTextTextItem(text: "${QagStrings.toolbarPart1}\n", style: AgoraRichTextItemStyle.bold),
                        AgoraRichTextTextItem(text: QagStrings.toolbarPart2, style: AgoraRichTextItemStyle.regular),
                      ],
                    ),
                    onProfileClick: () {
                      Navigator.pushNamed(context, ProfilePage.routeName).then(
                        (value) {
                          final shouldReloadPage = value as bool;
                          if (shouldReloadPage) {
                            context.read<QagBloc>().add(FetchQagsEvent(thematiqueId: currentThematiqueId));
                          }
                        },
                      );
                    },
                  ),
                  Column(children: _handleQagState(context, state)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _handleQagState(BuildContext context, QagState state) {
    if (state is QagWithItem) {
      return [
        QagsResponseSection(qagResponseViewModels: state.qagResponseViewModels),
        QagsAskQuestionSectionPage(errorCase: state.errorCase),
        QagsThematiqueSection(
          currentThematiqueId: currentThematiqueId,
          onThematiqueIdSelected: (String? thematiqueId) {
            if (currentThematiqueId != null || thematiqueId != null) {
              setState(() {
                if (thematiqueId == currentThematiqueId) {
                  currentThematiqueId = null;
                } else {
                  currentThematiqueId = thematiqueId;
                }
                TrackerHelper.trackClick(
                  clickName: "${AnalyticsEventNames.thematique} $currentThematiqueId",
                  widgetName: AnalyticsScreenNames.qagsPage,
                );
                context.read<QagBloc>().add(FetchQagsEvent(thematiqueId: currentThematiqueId));
              });
            }
          },
        ),
        QagsSection(
          isLoading: state is QagLoadingState,
          defaultSelected: QagTab.popular,
          popularViewModels: state.popularViewModels,
          latestViewModels: state.latestViewModels,
          supportingViewModels: state.supportingViewModels,
          selectedThematiqueId: currentThematiqueId,
          askQuestionErrorCase: state.errorCase,
        ),
      ];
    } else if (state is QagInitialLoadingState) {
      return _buildPadding(context, CircularProgressIndicator());
    } else if (state is QagErrorState && state.errorType == QagsErrorType.timeout) {
      return _buildPadding(
        context,
        AgoraErrorView(errorMessage: GenericStrings.timeoutErrorMessage, textAlign: TextAlign.center),
      );
    } else if (state is QagErrorState && state.errorType == QagsErrorType.generic) {
      return _buildPadding(context, AgoraErrorView());
    }
    return [];
  }

  List<Widget> _buildPadding(BuildContext context, Widget child) {
    return [
      Padding(
        padding: EdgeInsets.only(
          left: AgoraSpacings.horizontalPadding,
          top: AgoraSpacings.base,
          right: AgoraSpacings.horizontalPadding,
        ),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 10 * 3.5),
            Center(child: child),
            SizedBox(height: AgoraSpacings.x2),
          ],
        ),
      )
    ];
  }
}
