import 'package:agora/bloc/qag/ask_qag/ask_qag_bloc.dart';
import 'package:agora/bloc/qag/ask_qag/ask_qag_event.dart';
import 'package:agora/bloc/qag/ask_qag/ask_qag_state.dart';
import 'package:agora/bloc/qag/response/qag_response_bloc.dart';
import 'package:agora/bloc/qag/response/qag_response_event.dart';
import 'package:agora/bloc/qag/response/qag_response_state.dart';
import 'package:agora/bloc/qag/search/qag_search_bloc.dart';
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
  late final GlobalKey searchBarKey;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      toolbarTitleKey.currentContext?.findRenderObject()?.sendSemanticsEvent(FocusSemanticEvent());
      searchBarKey = GlobalKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AgoraTracker(
      widgetName: AnalyticsScreenNames.qagsPage,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => AskQagBloc(
              qagRepository: RepositoryManager.getQagRepository(),
            )..add(FetchAskQagStatusEvent()),
          ),
          BlocProvider(
            create: (BuildContext context) => QagResponseBloc(
              qagRepository: RepositoryManager.getQagRepository(),
            )..add(FetchQagsResponseEvent()),
          ),
          BlocProvider(
            create: (context) => ThematiqueBloc(
              repository: RepositoryManager.getThematiqueRepository(),
            )..add(FetchFilterThematiqueEvent()),
          ),
          BlocProvider(
            create: (context) => QagSearchBloc(
              qagRepository: RepositoryManager.getQagRepository(),
            ),
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
                      Navigator.pushNamed(context, ProfilePage.routeName);
                    },
                  ),
                  BlocBuilder<AskQagBloc, AskQagState>(
                    builder: (context, qagState) {
                      if (qagResponseState is QagResponseInitialLoadingState && qagState is AskQagInitialLoadingState) {
                        return QagsLoadingSkeleton();
                      } else if (qagResponseState is QagResponseErrorState && qagState is AskQagErrorState) {
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

  List<Widget> _handleQagState(BuildContext context, AskQagState state) {
    if (state is QagAskFetchedState) {
      return [
        QagsAskQuestionSectionPage(
          key: searchBarKey,
          errorCase: state.askQagError,
        ),
        QagsSection(
          defaultSelected: QagTab.popular,
          selectedThematiqueId: currentThematiqueId,
          onSearchBarOpen: (bool isSearchOpen) {
            if (isSearchOpen) {
              TrackerHelper.trackEvent(
                widgetName: AnalyticsScreenNames.qagsPage,
                eventName: AnalyticsEventNames.qagsSearch,
              );
              Scrollable.ensureVisible(
                searchBarKey.currentContext!,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            }
          },
        ),
      ];
    } else if (state is AskQagInitialLoadingState) {
      return [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding, vertical: AgoraSpacings.x2),
          child: CircularProgressIndicator(),
        ),
      ];
    } else if (state is AskQagErrorState) {
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
