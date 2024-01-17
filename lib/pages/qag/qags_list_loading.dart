import 'package:agora/design/custom_view/skeletons.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:flutter/material.dart';

class QagsListLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AgoraSpacings.horizontalPadding,
        top: AgoraSpacings.base,
        right: AgoraSpacings.horizontalPadding,
        bottom: AgoraSpacings.x2,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SkeletonBox(
            width: 500.0,
            height: 100.0,
          ),
          SizedBox(height: AgoraSpacings.x0_75),
          SkeletonBox(
            width: 500.0,
            height: 100.0,
          ),
        ],
      ),
    );
  }
}
