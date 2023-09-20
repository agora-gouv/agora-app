import 'package:agora/design/custom_view/skeletons.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:flutter/material.dart';

class QagsLoadingSkeleton extends StatelessWidget {
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
        children: [
          _buildQagHeader(context),
          SizedBox(height: AgoraSpacings.x0_75),
          Row(
            children: [
              SkeletonBox(
                width: 180.0,
                height: 184.0,
              ),
            ],
          ),
          SizedBox(height: AgoraSpacings.x0_75),
          _buildQagHeader(context),
          SizedBox(height: AgoraSpacings.x0_75),
          Row(
            children: [
              SkeletonBox(
                width: 76.0,
                height: 76.0,
              ),
              SizedBox(width: AgoraSpacings.x0_75),
              SkeletonBox(
                width: 76.0,
                height: 76.0,
              ),
              SizedBox(width: AgoraSpacings.x0_75),
              SkeletonBox(
                width: 76.0,
                height: 76.0,
              ),
            ],
          ),
          SizedBox(height: AgoraSpacings.x0_75),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.base),
                  child: SkeletonBox(),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.base),
                  child: SkeletonBox(),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.base),
                  child: SkeletonBox(),
                ),
              ),
            ],
          ),
          SizedBox(height: AgoraSpacings.x0_75),
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

  Widget _buildQagHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              SkeletonBox(),
              SizedBox(
                height: AgoraSpacings.x0_375,
              ),
              SkeletonBox(),
            ],
          ),
        ),
        SizedBox(width: AgoraSpacings.x6),
        SkeletonBox(
          width: 100,
          height: 30,
          radius: 20,
        ),
      ],
    );
  }
}
