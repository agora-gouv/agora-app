import 'package:agora/bloc/qag/qag_view_model.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_qag_card.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

enum QagTab { popular, lastest, supporting }

class QagsSection extends StatefulWidget {
  final QagTab defaultSelected;
  final List<QagViewModel> popularViewModels;
  final List<QagViewModel> latestViewModels;
  final List<QagViewModel> supportingViewModels;

  const QagsSection({
    super.key,
    required this.defaultSelected,
    required this.popularViewModels,
    required this.latestViewModels,
    required this.supportingViewModels,
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
          child: _buildQags(),
        ),
      ],
    );
  }

  Widget _buildQags() {
    switch (currentSelected) {
      case QagTab.popular:
        return Column(children: _buildQagWidgets(widget.popularViewModels));
      case QagTab.lastest:
        return Column(children: _buildQagWidgets(widget.latestViewModels));
      case QagTab.supporting:
        return Column(children: _buildQagWidgets(widget.supportingViewModels));
    }
  }

  List<Widget> _buildQagWidgets(List<QagViewModel> qagViewModels) {
    final List<Widget> qagsWidgets = [];
    if (qagViewModels.isNotEmpty) {
      for (final qagViewModel in qagViewModels) {
        qagsWidgets.add(
          AgoraQagCard(
            id: qagViewModel.id,
            thematique: qagViewModel.thematique,
            title: qagViewModel.title,
            username: qagViewModel.username,
            date: qagViewModel.date,
            supportCount: qagViewModel.supportCount,
            isSupported: qagViewModel.isSupported,
          ),
        );
        qagsWidgets.add(SizedBox(height: AgoraSpacings.base));
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
                isSelected: currentSelected == QagTab.lastest,
                onTap: () {
                  setState(() => currentSelected = QagTab.lastest);
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
