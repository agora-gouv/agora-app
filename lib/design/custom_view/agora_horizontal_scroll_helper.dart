import 'dart:math';

import 'package:agora/design/custom_view/button/agora_icon_button.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:flutter/material.dart';

class HorizontalScrollHelper extends StatelessWidget {
  final int elementsNumber;
  final ScrollController scrollController;

  HorizontalScrollHelper({
    required this.elementsNumber,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(width: AgoraSpacings.base),
        AgoraIconButton(
          icon: 'ic_backward.svg',
          semanticLabel: 'Scroll vers la gauche',
          iconSize: 24,
          iconColor: AgoraColors.primaryBlue,
          borderColor: AgoraColors.orochimaru,
          round: true,
          onClick: () {
            scrollController.animateTo(
              scrollController.offset - (scrollController.position.maxScrollExtent / elementsNumber),
              duration: Duration(milliseconds: 300),
              curve: Curves.fastEaseInToSlowEaseOut,
            );
          },
        ),
        const SizedBox(width: AgoraSpacings.base),
        Expanded(
          child: Center(child: _HorizontalHelper(elementsNumber: elementsNumber, scrollController: scrollController)),
        ),
        const SizedBox(width: AgoraSpacings.base),
        AgoraIconButton(
          icon: 'ic_forward.svg',
          iconSize: 22,
          iconColor: AgoraColors.primaryBlue,
          semanticLabel: 'Scroll vers la droite',
          borderColor: AgoraColors.orochimaru,
          backgroundColor: Colors.white,
          round: true,
          onClick: () {
            scrollController.animateTo(
              scrollController.offset + (scrollController.position.maxScrollExtent / elementsNumber),
              duration: Duration(milliseconds: 300),
              curve: Curves.fastEaseInToSlowEaseOut,
            );
          },
        ),
        const SizedBox(width: AgoraSpacings.base),
      ],
    );
  }
}

class _HorizontalHelper extends StatefulWidget {
  final int elementsNumber;
  final ScrollController scrollController;

  _HorizontalHelper({
    required this.elementsNumber,
    required this.scrollController,
  });

  @override
  State<_HorizontalHelper> createState() => _HorizontalHelperState();
}

class _HorizontalHelperState extends State<_HorizontalHelper> {
  int currentIndex = 1;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScrollUpdated);
  }

  @override
  void dispose() {
    super.dispose();
    widget.scrollController.removeListener(_onScrollUpdated);
  }

  void _onScrollUpdated() {
    final index =
        widget.scrollController.offset * widget.elementsNumber / widget.scrollController.position.maxScrollExtent;
    final intIndex = min(widget.elementsNumber, 1 + index.round());
    if (intIndex != currentIndex) {
      setState(() {
        currentIndex = intIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dots =
        List<int>.generate(widget.elementsNumber, (i) => i + 1).map((i) => _Circle(i == currentIndex)).toList();
    return Semantics(
      label: "Élément $currentIndex sur ${widget.elementsNumber}",
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: dots,
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  final bool isCurrent;

  _Circle(this.isCurrent);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AgoraSpacings.x0_375),
      child: Container(
        width: isCurrent ? 12 : 6,
        height: isCurrent ? 12 : 6,
        decoration: BoxDecoration(
          color: isCurrent ? AgoraColors.blue525 : AgoraColors.gravelFint,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
