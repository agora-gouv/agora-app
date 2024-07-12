import 'package:agora/common/helper/responsive_helper.dart';
import 'package:agora/design/custom_view/skeletons.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:flutter/material.dart';

class ConsultationsLoadingSkeleton extends StatelessWidget {
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
          SizedBox(height: AgoraSpacings.base),
          _OnGoingConsultationLoadingItem(),
          SizedBox(height: AgoraSpacings.base),
          _OnGoingConsultationLoadingItem(),
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

class _OnGoingConsultationLoadingItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (ResponsiveHelper.isLargerThanMobile(context)) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: SkeletonBox(
              height: 400.0,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: SkeletonBox(
              height: 400.0,
            ),
          ),
        ],
      );
    } else {
      return SkeletonBox(
        width: 400.0,
        height: 400.0,
      );
    }
  }
}
