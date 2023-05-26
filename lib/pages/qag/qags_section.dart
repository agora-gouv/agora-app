import 'package:agora/bloc/qag/qag_bloc.dart';
import 'package:agora/bloc/qag/qag_event.dart';
import 'package:agora/bloc/qag/qag_view_model.dart';
import 'package:agora/bloc/qag/support/qag_support_bloc.dart';
import 'package:agora/bloc/qag/support/qag_support_event.dart';
import 'package:agora/bloc/qag/support/qag_support_state.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_alert_dialog.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_qag_card.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/button/agora_rounded_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/qag/details/qag_details_page.dart';
import 'package:agora/pages/qag/paginated/qags_paginated_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum QagTab { popular, latest, supporting }

class QagsSection extends StatefulWidget {
  final QagTab defaultSelected;
  final List<QagViewModel> popularViewModels;
  final List<QagViewModel> latestViewModels;
  final List<QagViewModel> supportingViewModels;
  final String? selectedThematiqueId;

  const QagsSection({
    super.key,
    required this.defaultSelected,
    required this.popularViewModels,
    required this.latestViewModels,
    required this.supportingViewModels,
    required this.selectedThematiqueId,
  });

  @override
  State<QagsSection> createState() => _QagsSectionState();
}

class _QagsSectionState extends State<QagsSection> {
  late QagTab currentSelected;

  @override
  void initState() {
    super.initState();
    currentSelected = widget.defaultSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTabBar(),
        Padding(
          padding: const EdgeInsets.only(
            left: AgoraSpacings.horizontalPadding,
            right: AgoraSpacings.horizontalPadding,
            top: AgoraSpacings.base,
          ),
          child: _buildQags(context),
        ),
      ],
    );
  }

  Widget _buildQags(BuildContext context) {
    switch (currentSelected) {
      case QagTab.popular:
        return Column(children: _buildQagWidgets(context, widget.popularViewModels, currentSelected));
      case QagTab.latest:
        return Column(children: _buildQagWidgets(context, widget.latestViewModels, currentSelected));
      case QagTab.supporting:
        return Column(children: _buildQagWidgets(context, widget.supportingViewModels, currentSelected));
    }
  }

  List<Widget> _buildQagWidgets(BuildContext context, List<QagViewModel> qagViewModels, QagTab qagTab) {
    final List<Widget> qagsWidgets = [];
    if (qagViewModels.isNotEmpty) {
      for (final qagViewModel in qagViewModels) {
        qagsWidgets.add(
          BlocConsumer<QagSupportBloc, QagSupportState>(
            listenWhen: (previousState, currentState) {
              return (currentState is QagSupportSuccessState && currentState.qagId == qagViewModel.id) ||
                  (currentState is QagDeleteSupportSuccessState && currentState.qagId == qagViewModel.id) ||
                  (currentState is QagSupportErrorState && currentState.qagId == qagViewModel.id) ||
                  (currentState is QagDeleteSupportErrorState && currentState.qagId == qagViewModel.id);
            },
            listener: (previousState, currentState) {
              if (currentState is QagSupportSuccessState || currentState is QagDeleteSupportSuccessState) {
                context.read<QagBloc>().add(
                      UpdateQagsEvent(
                        qagId: qagViewModel.id,
                        thematique: qagViewModel.thematique,
                        title: qagViewModel.title,
                        username: qagViewModel.username,
                        date: qagViewModel.date,
                        supportCount: _buildCount(qagViewModel, currentState),
                        isSupported: !qagViewModel.isSupported,
                      ),
                    );
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
            builder: (context, state) {
              return AgoraQagCard(
                id: qagViewModel.id,
                thematique: qagViewModel.thematique,
                title: qagViewModel.title,
                username: qagViewModel.username,
                date: qagViewModel.date,
                supportCount: qagViewModel.supportCount,
                isSupported: qagViewModel.isSupported,
                onSupportClick: (support) {
                  if (support) {
                    context.read<QagSupportBloc>().add(SupportQagEvent(qagId: qagViewModel.id));
                  } else {
                    context.read<QagSupportBloc>().add(DeleteSupportQagEvent(qagId: qagViewModel.id));
                  }
                },
                onCardClick: () {
                  Navigator.pushNamed(
                    context,
                    QagDetailsPage.routeName,
                    arguments: QagDetailsArguments(qagId: qagViewModel.id),
                  ).then((result) {
                    final qagDetailsBackResult = result as QagDetailsBackResult?;
                    if (qagDetailsBackResult != null) {
                      context.read<QagBloc>().add(
                            UpdateQagsEvent(
                              qagId: qagDetailsBackResult.qagId,
                              thematique: qagDetailsBackResult.thematique,
                              title: qagDetailsBackResult.title,
                              username: qagDetailsBackResult.username,
                              date: qagDetailsBackResult.date,
                              supportCount: qagDetailsBackResult.supportCount,
                              isSupported: qagDetailsBackResult.isSupported,
                            ),
                          );
                      setState(() {}); // do not remove: utils to update screen
                    }
                  });
                },
              );
            },
          ),
        );
        qagsWidgets.add(SizedBox(height: AgoraSpacings.base));
      }
      switch (qagTab) {
        case QagTab.popular:
          qagsWidgets.add(_buildAllButton(QagPaginatedInitialTab.popular));
          qagsWidgets.add(SizedBox(height: AgoraSpacings.base));
          break;
        case QagTab.latest:
          qagsWidgets.add(_buildAllButton(QagPaginatedInitialTab.latest));
          qagsWidgets.add(SizedBox(height: AgoraSpacings.base));
          break;
        case QagTab.supporting:
          qagsWidgets.add(_buildAllButton(QagPaginatedInitialTab.supporting));
          qagsWidgets.add(SizedBox(height: AgoraSpacings.base));
          break;
      }
      return qagsWidgets;
    } else {
      return [
        SizedBox(
          height: MediaQuery.of(context).size.height - (AgoraSpacings.x3 * 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(QagStrings.emptyList),
              SizedBox(height: AgoraSpacings.x3 * 3),
            ],
          ),
        ),
      ];
    }
  }

  int _buildCount(QagViewModel qagViewModel, QagSupportState supportState) {
    final supportCount = qagViewModel.supportCount;
    if (supportState is QagSupportSuccessState) {
      return supportCount + 1;
    } else if (supportState is QagDeleteSupportSuccessState) {
      return supportCount - 1;
    }
    return supportCount;
  }

  Row _buildAllButton(QagPaginatedInitialTab initialTab) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AgoraRoundedButton(
          label: GenericStrings.all,
          style: AgoraRoundedButtonStyle.primaryButton,
          onPressed: () {
            Navigator.pushNamed(
              context,
              QagsPaginatedPage.routeName,
              arguments: QagsPaginatedArguments(thematiqueId: widget.selectedThematiqueId, initialTab: initialTab),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Column(
      children: [
        SizedBox(height: AgoraSpacings.base),
        Row(
          children: [
            Expanded(
              child: _buildTabButton(
                label: QagStrings.popular,
                isSelected: currentSelected == QagTab.popular,
                onTap: () {
                  setState(() => currentSelected = QagTab.popular);
                },
              ),
            ),
            Expanded(
              child: _buildTabButton(
                label: QagStrings.latest,
                isSelected: currentSelected == QagTab.latest,
                onTap: () {
                  setState(() => currentSelected = QagTab.latest);
                },
              ),
            ),
            Expanded(
              child: _buildTabButton(
                label: QagStrings.supporting,
                isSelected: currentSelected == QagTab.supporting,
                onTap: () {
                  setState(() => currentSelected = QagTab.supporting);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTabButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () => onTap(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: AgoraSpacings.horizontalPadding,
              right: AgoraSpacings.horizontalPadding,
              top: AgoraSpacings.base,
              bottom: AgoraSpacings.base,
            ),
            child: Text(label, style: isSelected ? AgoraTextStyles.medium14 : AgoraTextStyles.light14),
          ),
          if (isSelected)
            Container(
              color: AgoraColors.primaryGreen,
              height: 3,
              width: MediaQuery.of(context).size.width * 0.3,
            ),
        ],
      ),
    );
  }
}
