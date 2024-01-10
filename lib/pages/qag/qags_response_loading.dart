import 'package:agora/common/helper/responsive_helper.dart';
import 'package:agora/design/custom_view/skeletons.dart';
import 'package:flutter/material.dart';

class QagsResponseLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SkeletonBox(
                width: 180.0,
                height: 184.0,
              ),
              if (ResponsiveHelper.isLargerThanMobile(context)) ...[
                const SizedBox(width: 20),
                SkeletonBox(
                  width: 180.0,
                  height: 184.0,
                ),
                const SizedBox(width: 20),
                SkeletonBox(
                  width: 180.0,
                  height: 184.0,
                ),
                const SizedBox(width: 20),
                SkeletonBox(
                  width: 180.0,
                  height: 184.0,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
