import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonItem extends StatelessWidget {
  final EdgeInsetsGeometry padding;

  const SkeletonItem({this.padding = const EdgeInsets.symmetric(horizontal: AgoraSpacings.base)});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(height: 12),
          SkeletonBox(width: 92.0, height: 8.0),
          SizedBox(height: 12),
          SkeletonBox(width: 208.0),
        ],
      ),
    );
  }
}

class SkeletonBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double radius;

  const SkeletonBox({
    super.key,
    this.width,
    this.height = AgoraSpacings.x0_75,
    this.radius = AgoraCorners.defaultRadius,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        height: height,
        child: Shimmer.fromColors(
          baseColor: AgoraColors.orochimaru,
          highlightColor: AgoraColors.superSilver,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius), color: AgoraColors.white),
            height: 12,
            width: width,
          ),
        ),
      );
}

class SkeletonCircle extends StatelessWidget {
  final double radius;

  const SkeletonCircle({super.key, required this.radius});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: radius,
        height: radius,
        child: Shimmer.fromColors(
          baseColor: AgoraColors.orochimaru,
          highlightColor: AgoraColors.steam,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius), color: AgoraColors.white),
            height: radius,
            width: radius,
          ),
        ),
      );
}

class SkeletonProfileItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 12, top: 12),
      child: Row(
        children: [
          const SkeletonCircle(radius: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SkeletonBox(width: 92.0, height: 8.0),
                SizedBox(height: 4),
                SkeletonBox(width: 152.0),
              ],
            ),
          ),
          const SizedBox(height: 12, width: 38),
        ],
      ),
    );
  }
}

class ProfileItemSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.0), color: AgoraColors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SkeletonProfileItem(),
            SkeletonProfileItem(),
          ],
        ),
      );
}
