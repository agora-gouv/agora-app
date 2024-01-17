import 'package:agora/common/helper/responsive_helper.dart';
import 'package:agora/design/custom_view/skeletons.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:flutter/material.dart';

class QagsThematiqueLoading extends StatelessWidget {
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
          SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Row(
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
                if (ResponsiveHelper.isLargerThanMobile(context)) ...[
                  const SizedBox(width: AgoraSpacings.x0_75),
                  SkeletonBox(
                    width: 76.0,
                    height: 76.0,
                  ),
                  const SizedBox(width: AgoraSpacings.x0_75),
                  SkeletonBox(
                    width: 76.0,
                    height: 76.0,
                  ),
                  const SizedBox(width: AgoraSpacings.x0_75),
                  SkeletonBox(
                    width: 76.0,
                    height: 76.0,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
