import 'package:agora/bloc/qag/similar/qag_similar_bloc.dart';
import 'package:agora/bloc/qag/similar/qag_similar_event.dart';
import 'package:agora/bloc/qag/similar/qag_similar_state.dart';
import 'package:agora/bloc/qag/similar/qag_similar_view_model.dart';
import 'package:agora/bloc/qag/support/qag_support_bloc.dart';
import 'package:agora/bloc/qag/support/qag_support_event.dart';
import 'package:agora/bloc/qag/support/qag_support_state.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_alert_dialog.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_qag_similar_card.dart';
import 'package:agora/design/custom_view/agora_rich_text.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_secondary_style_view.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/consultation/consultations_page.dart';
import 'package:agora/pages/loading_page.dart';
import 'package:agora/pages/qag/qags_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagSimilarPage extends StatefulWidget {
  static const routeName = "/qagSimilarPage";

  @override
  State<QagSimilarPage> createState() => _QagSimilarPageState();
}

class _QagSimilarPageState extends State<QagSimilarPage> {
  bool shouldReloadQags = false;

  @override
  Widget build(BuildContext context) {
    final title = ModalRoute.of(context)!.settings.arguments as String;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => QagSimilarBloc(
            qagRepository: RepositoryManager.getQagRepository(),
          )..add(GetQagSimilarEvent(title: title)),
        ),
        BlocProvider(
          create: (BuildContext context) => QagSupportBloc(qagRepository: RepositoryManager.getQagRepository()),
        ),
      ],
      child: AgoraScaffold(
        popAction: () {
          _backAction(context);
          return true;
        },
        child: BlocBuilder<QagSimilarBloc, QagSimilarState>(
          builder: (context, state) {
            return AgoraSecondaryStyleView(
              title: AgoraRichText(
                policeStyle: AgoraRichTextPoliceStyle.toolbar,
                items: [
                  AgoraRichTextTextItem(
                    text: QagStrings.similarQagTitle1,
                    style: AgoraRichTextItemStyle.bold,
                  ),
                  AgoraRichTextTextItem(
                    text: QagStrings.similarQagTitle2,
                    style: AgoraRichTextItemStyle.regular,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
                child: _buildState(context, state),
              ),
            );
          },
        ),
      ),
    );
  }

  void _backAction(BuildContext context) => Navigator.pop(context, shouldReloadQags);

  Widget _buildState(BuildContext context, QagSimilarState state) {
    switch (state) {
      case QagSimilarSuccessState():
        return Column(
          children: [
            Text(QagStrings.similarQagDescription, style: AgoraTextStyles.light14),
            SizedBox(height: AgoraSpacings.base),
            ...buildCard(context, state.similarQags),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: AgoraButton(
                    label: GenericStrings.close,
                    style: AgoraButtonStyle.blueBorderButtonStyle,
                    onPressed: () {
                      if (shouldReloadQags) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          QagsPage.routeName,
                          ModalRoute.withName(LoadingPage.routeName),
                        );
                      } else {
                        Navigator.popUntil(
                          context,
                          (route) =>
                              route.settings.name == QagsPage.routeName ||
                              route.settings.name == ConsultationsPage.routeName,
                        );
                      }
                    },
                  ),
                ),
                SizedBox(width: AgoraSpacings.base),
                AgoraButton(
                  label: QagStrings.returnToQuestion,
                  style: AgoraButtonStyle.primaryButtonStyle,
                  onPressed: () => _backAction(context),
                ),
              ],
            ),
            SizedBox(height: AgoraSpacings.base),
          ],
        );
      case QagSimilarInitialState():
      case QagSimilarLoadingState():
        return Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 10 * 3.5),
            Center(child: CircularProgressIndicator()),
          ],
        );
      case QagSimilarErrorState():
        return Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 10 * 3.5),
            Center(child: AgoraErrorView()),
          ],
        );
    }
  }

  List<Widget> buildCard(BuildContext context, List<QagSimilarViewModel> similarQags) {
    final List<Widget> widgets = [];
    for (final similarQag in similarQags) {
      widgets.add(
        BlocConsumer<QagSupportBloc, QagSupportState>(
          listenWhen: (previousState, currentState) {
            return (currentState is QagSupportSuccessState && currentState.qagId == similarQag.id) ||
                (currentState is QagDeleteSupportSuccessState && currentState.qagId == similarQag.id) ||
                (currentState is QagSupportErrorState && currentState.qagId == similarQag.id) ||
                (currentState is QagDeleteSupportErrorState && currentState.qagId == similarQag.id);
          },
          listener: (previousState, currentState) {
            if (currentState is QagSupportSuccessState || currentState is QagDeleteSupportSuccessState) {
              context.read<QagSimilarBloc>().add(
                    UpdateSimilarQagEvent(
                      qagId: similarQag.id,
                      supportCount: _buildCount(similarQag, currentState),
                      isSupported: !similarQag.isSupported,
                    ),
                  );
              shouldReloadQags = true;
            } else if (currentState is QagSupportErrorState || currentState is QagDeleteSupportErrorState) {
              showAgoraDialog(
                context: context,
                columnChildren: [
                  AgoraErrorView(),
                  SizedBox(height: AgoraSpacings.x0_75),
                  AgoraButton(
                    label: GenericStrings.close,
                    style: AgoraButtonStyle.primaryButtonStyle,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              );
            }
          },
          buildWhen: (previousState, currentState) {
            return currentState is QagSupportInitialState ||
                currentState is QagSupportLoadingState ||
                currentState is QagDeleteSupportLoadingState ||
                (currentState is QagSupportSuccessState && currentState.qagId == similarQag.id) ||
                (currentState is QagDeleteSupportSuccessState && currentState.qagId == similarQag.id);
          },
          builder: (context, state) {
            return AgoraQagSimilarCard(
              id: similarQag.id,
              thematique: similarQag.thematique,
              title: similarQag.title,
              description: similarQag.description,
              username: similarQag.username,
              date: similarQag.date,
              supportCount: similarQag.supportCount,
              isSupported: similarQag.isSupported,
              onSupportClick: (support) {
                if (support) {
                  TrackerHelper.trackClick(
                    clickName: AnalyticsEventNames.likeQag,
                    widgetName: AnalyticsScreenNames.qagSimilarPage,
                  );
                  context.read<QagSupportBloc>().add(SupportQagEvent(qagId: similarQag.id));
                } else {
                  TrackerHelper.trackClick(
                    clickName: AnalyticsEventNames.unlikeQag,
                    widgetName: AnalyticsScreenNames.qagSimilarPage,
                  );
                  context.read<QagSupportBloc>().add(DeleteSupportQagEvent(qagId: similarQag.id));
                }
              },
            );
          },
        ),
      );
      widgets.add(SizedBox(height: AgoraSpacings.base));
    }
    return widgets;
  }

  int _buildCount(QagSimilarViewModel qagSimilarViewModel, QagSupportState supportState) {
    final supportCount = qagSimilarViewModel.supportCount;
    if (supportState is QagSupportSuccessState) {
      return supportCount + 1;
    } else if (supportState is QagDeleteSupportSuccessState) {
      return supportCount - 1;
    }
    return supportCount;
  }
}
