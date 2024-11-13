import 'package:agora/design/style/agora_colors.dart';
import 'package:flutter/material.dart';

class UnreadCheck extends StatelessWidget {
  final bool isPositioned;
  final double? rightPosition;
  final double? topPosition;

  const UnreadCheck({this.isPositioned = false, this.rightPosition, this.topPosition});

  @override
  Widget build(BuildContext context) {
    if (isPositioned) {
      return Positioned(
        right: rightPosition,
        top: topPosition,
        child: _Check(),
      );
    } else {
      return _Check();
    }
  }
}

class _Check extends StatelessWidget {
  const _Check();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Vous avez une fonctionnalité a voir',
      child: Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
          color: AgoraColors.red,
          border: Border.all(color: Colors.white, strokeAlign: BorderSide.strokeAlignOutside),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
