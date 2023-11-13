import 'package:agora/bloc/qag/qag_bloc.dart';
import 'package:agora/bloc/qag/qag_event.dart';
import 'package:agora/bloc/qag/qag_state.dart';
import 'package:agora/bloc/qag/response/qag_response_bloc.dart';
import 'package:agora/bloc/qag/response/qag_response_event.dart';
import 'package:agora/bloc/qag/response/qag_response_state.dart';
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
import 'package:agora/pages/qag/qags_loading_skeleton.dart';
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
            create: (BuildContext context) => QagResponseBloc(
              qagRepository: RepositoryManager.getQagRepository(),
            )..add(FetchQagsResponseEvent()),
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
        child: BlocBuilder<QagResponseBloc, QagResponseState>(
          builder: (context, qagResponseState) {
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
                        AgoraRichTextItem(text: "${QagStrings.toolbarPart1}\n", style: AgoraRichTextItemStyle.bold),
                        AgoraRichTextItem(text: QagStrings.toolbarPart2, style: AgoraRichTextItemStyle.regular),
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
                  BlocBuilder<QagBloc, QagState>(
                    builder: (context, qagState) {
                      if (qagResponseState is QagResponseInitialLoadingState && qagState is QagInitialLoadingState) {
                        return QagsLoadingSkeleton();
                      } else if (qagResponseState is QagResponseErrorState && qagState is QagErrorState) {
                        return _buildGlobalPadding(context, child: AgoraErrorView());
                      }
                      return Column(
                        children: [
                          _handleQagResponseState(qagResponseState),
                          ..._handleQagState(context, qagState),
                        ],
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _handleQagResponseState(QagResponseState state) {
    switch (state) {
      case QagResponseInitialLoadingState():
        return _buildLocalPadding(
          child: Center(child: CircularProgressIndicator()),
        );
      case QagResponseFetchedState():
        return QagsResponseSection(qagResponseViewModels: state.qagResponseViewModels);
      case QagResponseErrorState():
        return _buildLocalPadding(
          child: Center(child: AgoraErrorView()),
        );
    }
  }

  List<Widget> _handleQagState(BuildContext context, QagState state) {
    if (state is QagWithItemState) {
      return [
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
          popupViewModel: state.popupViewModel,
        ),
      ];
    } else if (state is QagInitialLoadingState) {
      return [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding, vertical: AgoraSpacings.x2),
          child: CircularProgressIndicator(),
        ),
      ];
    } else if (state is QagErrorState) {
      switch (state.errorType) {
        case QagsErrorType.generic:
          return [_buildLocalPadding(child: AgoraErrorView())];
        case QagsErrorType.timeout:
          return [
            _buildLocalPadding(
              child: AgoraErrorView(errorMessage: GenericStrings.timeoutErrorMessage, textAlign: TextAlign.center),
            ),
          ];
      }
    }
    return [];
  }

  Widget _buildGlobalPadding(BuildContext context, {required Widget child}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 10 * 3),
          Center(child: child),
          SizedBox(height: AgoraSpacings.x2),
        ],
      ),
    );
  }

  Widget _buildLocalPadding({required Widget child}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding, vertical: AgoraSpacings.x2),
      child: child,
    );
  }
}
