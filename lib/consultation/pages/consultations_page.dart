import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/consultation/bloc/consultation_bloc.dart';
import 'package:agora/consultation/bloc/consultation_event.dart';
import 'package:agora/consultation/bloc/consultation_state.dart';
import 'package:agora/consultation/domain/consultations_error_type.dart';
import 'package:agora/consultation/pages/widgets/consultations_answered_section.dart';
import 'package:agora/consultation/pages/widgets/consultations_finished_section.dart';
import 'package:agora/consultation/pages/widgets/consultations_loading_skeleton.dart';
import 'package:agora/consultation/pages/widgets/consultations_ongoing_section.dart';
import 'package:agora/design/custom_view/agora_main_toolbar.dart';
import 'package:agora/design/custom_view/agora_tracker.dart';
import 'package:agora/design/custom_view/error/agora_error_view.dart';
import 'package:agora/design/custom_view/text/agora_rich_text.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
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
            concertationRepository: RepositoryManager.getConcertationRepository(),
          )..add(FetchConsultationsEvent());
        },
        child: BlocBuilder<ConsultationBloc, ConsultationState>(
          builder: (context, state) {
            return SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                children: [
                  _Header(toolbarTitleKey: toolbarTitleKey),
                  _Content(state: state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final ConsultationState state;

  const _Content({required this.state});

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      ConsultationInitialLoadingState _ => ConsultationsLoadingSkeleton(),
      final ConsultationsFetchedState successState => _Success(successState: successState),
      final ConsultationErrorState errorState => _ErrorWidget(errorState: errorState),
    };
  }
}

class _Success extends StatelessWidget {
  final ConsultationsFetchedState successState;

  const _Success({required this.successState});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConsultationsOngoingSection(
          ongoingViewModels: successState.ongoingViewModels,
          answeredSectionEmpty: successState.answeredViewModels.isEmpty,
        ),
        ConsultationsFinishedSection(
          finishedViewModels: successState.finishedViewModels,
          shouldDisplayAllButton: successState.shouldDisplayFinishedAllButton,
        ),
        ConsultationsAnsweredSection(answeredViewModels: successState.answeredViewModels),
        _SuccessFooter(),
      ],
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final ConsultationErrorState errorState;

  const _ErrorWidget({required this.errorState});

  @override
  Widget build(BuildContext context) {
    final errorMessage = errorState.errorType == ConsultationsErrorType.timeout
        ? GenericStrings.timeoutErrorMessage
        : GenericStrings.errorMessage;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 10 * 3),
              Center(
                child: AgoraErrorView(
                  errorMessage: errorMessage,
                  textAlign: TextAlign.center,
                  onReload: () => context.read<ConsultationBloc>().add(FetchConsultationsEvent()),
                ),
              ),
              SizedBox(height: AgoraSpacings.x2),
            ],
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final GlobalKey<State<StatefulWidget>> toolbarTitleKey;

  const _Header({required this.toolbarTitleKey});

  @override
  Widget build(BuildContext context) {
    return AgoraMainToolbar(
      title: AgoraRichText(
        key: toolbarTitleKey,
        policeStyle: AgoraRichTextPoliceStyle.toolbar,
        semantic: AgoraRichTextSemantic(focused: true),
        items: [
          AgoraRichTextItem(
            text: "${ConsultationStrings.toolbarPart1}\n",
            style: AgoraRichTextItemStyle.bold,
          ),
          AgoraRichTextItem(
            text: ConsultationStrings.toolbarPart2,
            style: AgoraRichTextItemStyle.regular,
          ),
        ],
      ),
    );
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
          ExcludeSemantics(child: Text('🤝', style: AgoraTextStyles.regular26)),
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
