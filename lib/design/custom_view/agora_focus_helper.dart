import 'package:flutter/material.dart';

class AgoraFocusHelper extends StatelessWidget {
  final GlobalKey elementKey;
  final Widget child;

  const AgoraFocusHelper({required this.elementKey, required this.child});

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      canRequestFocus: false,
      onFocusChange: (requestFocus) {
        if (requestFocus) {
          Scrollable.ensureVisible(
            elementKey.currentContext!,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart,
          );
        }
      },
      child: child,
    );
  }
}
