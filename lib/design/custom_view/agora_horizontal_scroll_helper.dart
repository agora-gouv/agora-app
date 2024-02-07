import 'dart:math';

import 'package:agora/design/custom_view/button/agora_icon_button.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:flutter/material.dart';

class HorizontalScrollHelper extends StatefulWidget {
  final int itemsCount;
  final ScrollController scrollController;

  HorizontalScrollHelper({
    required this.itemsCount,
    required this.scrollController,
  });

  @override
  State<HorizontalScrollHelper> createState() => _HorizontalScrollHelperState();
}

class _HorizontalScrollHelperState extends State<HorizontalScrollHelper> {
  bool hasReachedLeftEnd = true;
  bool hasReachedRightEnd = false;

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
    final offset = widget.scrollController.offset;
    final maxScrollExtent = widget.scrollController.position.maxScrollExtent;
    if (offset <= 0) {
      if (!hasReachedLeftEnd) {
        setState(() {
          hasReachedLeftEnd = true;
          hasReachedRightEnd = false;
        });
      }
    } else if (offset >= maxScrollExtent) {
      if (!hasReachedRightEnd) {
        setState(() {
          hasReachedRightEnd = true;
          hasReachedLeftEnd = false;
        });
      }
    } else if (hasReachedRightEnd || hasReachedLeftEnd) {
      setState(() {
        hasReachedRightEnd = false;
        hasReachedLeftEnd = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(width: AgoraSpacings.base),
        Opacity(
          opacity: hasReachedLeftEnd ? 0.5 : 1,
          child: AgoraIconButton(
            icon: 'ic_backward_helper.svg',
            semanticLabel: 'Scroll vers la gauche',
            iconSize: 16,
            iconColor: AgoraColors.primaryBlue,
            borderColor: AgoraColors.orochimaru,
            backgroundColor: hasReachedLeftEnd ? Colors.transparent : Colors.white,
            round: true,
            padding: AgoraSpacings.base,
            onClick: () {
              if (hasReachedLeftEnd) return;
              widget.scrollController.animateTo(
                widget.scrollController.offset - (widget.scrollController.position.maxScrollExtent / widget.itemsCount),
                duration: Duration(milliseconds: 300),
                curve: Curves.fastEaseInToSlowEaseOut,
              );
            },
          ),
        ),
        const SizedBox(width: AgoraSpacings.base),
        Expanded(
          child: Center(
              child: _HorizontalHelper(itemsCount: widget.itemsCount, scrollController: widget.scrollController)),
        ),
        const SizedBox(width: AgoraSpacings.base),
        Opacity(
          opacity: hasReachedRightEnd ? 0.5 : 1,
          child: AgoraIconButton(
            icon: 'ic_forward_helper.svg',
            iconSize: 16,
            iconColor: AgoraColors.primaryBlue,
            semanticLabel: 'Scroll vers la droite',
            borderColor: AgoraColors.orochimaru,
            backgroundColor: hasReachedRightEnd ? Colors.transparent : Colors.white,
            padding: AgoraSpacings.base,
            round: true,
            onClick: () {
              if (hasReachedRightEnd) return;
              widget.scrollController.animateTo(
                widget.scrollController.offset + (widget.scrollController.position.maxScrollExtent / widget.itemsCount),
                duration: Duration(milliseconds: 300),
                curve: Curves.fastEaseInToSlowEaseOut,
              );
            },
          ),
        ),
        const SizedBox(width: AgoraSpacings.base),
      ],
    );
  }
}

class _HorizontalHelper extends StatefulWidget {
  final int itemsCount;
  final ScrollController scrollController;

  _HorizontalHelper({
    required this.itemsCount,
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
    final index = widget.scrollController.offset * widget.itemsCount / widget.scrollController.position.maxScrollExtent;
    final intIndex = min(widget.itemsCount, 1 + index.round());
    if (intIndex != currentIndex) {
      setState(() {
        currentIndex = intIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dots = List<int>.generate(widget.itemsCount, (i) => i + 1).map((i) => _Circle(i == currentIndex)).toList();
    return Semantics(
      label: "Élément $currentIndex sur ${widget.itemsCount}",
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
          color: isCurrent ? AgoraColors.primaryBlue : AgoraColors.gravelFint,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
