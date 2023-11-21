import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

enum AgoraLikeStyle {
  police12,
  police14,
}

class AgoraLikeView extends StatelessWidget {
  final bool isSupported;
  final int supportCount;
  final bool shouldHaveHorizontalPadding;
  final bool shouldHaveVerticalPadding;
  final AgoraLikeStyle style;
  final Function(bool support)? onSupportClick;

  const AgoraLikeView({
    super.key,
    required this.isSupported,
    required this.supportCount,
    this.shouldHaveHorizontalPadding = true,
    this.shouldHaveVerticalPadding = false,
    this.style = AgoraLikeStyle.police14,
    this.onSupportClick,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onSupportClick != null,
      child: Stack(
        children: [
          InkWell(
            borderRadius: BorderRadius.all(AgoraCorners.rounded42),
            onTap: onSupportClick != null ? () => onSupportClick!(!isSupported) : null,
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(AgoraCorners.rounded42),
                border: Border.all(color: AgoraColors.lightRedOpacity19),
                color: AgoraColors.lightRedOpacity4,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: shouldHaveHorizontalPadding ? AgoraSpacings.x0_75 : 0,
                  vertical: shouldHaveVerticalPadding ? 2 : 0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(_getIcon(), width: _buildIconSize(), excludeFromSemantics: true),
                    SizedBox(width: AgoraSpacings.x0_25),
                    Padding(
                      padding: const EdgeInsets.only(bottom: AgoraSpacings.x0_25),
                      child: Text(
                        supportCount.toString(),
                        style: _buildTextStyle(),
                        semanticsLabel:
                            "${isSupported ? SemanticsStrings.support : SemanticsStrings.notSupport}\n${SemanticsStrings.supportNumber.format(supportCount.toString())}",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _AgoraLikeAnimationLoader(iconSize: _buildIconSize()),
        ],
      ),
    );
  }

  double _buildIconSize() {
    switch (style) {
      case AgoraLikeStyle.police12:
        return 14;
      case AgoraLikeStyle.police14:
        return 18;
    }
  }

  TextStyle _buildTextStyle() {
    switch (style) {
      case AgoraLikeStyle.police12:
        return AgoraTextStyles.medium12;
      case AgoraLikeStyle.police14:
        return AgoraTextStyles.medium14;
    }
  }

  String _getIcon() {
    if (isSupported) {
      return "assets/ic_heart_full.svg";
    } else {
      return "assets/ic_heart.svg";
    }
  }
}

class _AgoraLikeAnimationLoader extends StatelessWidget {
  final double iconSize;

  const _AgoraLikeAnimationLoader({required this.iconSize});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _loadPainter(),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        } else if (snapshot.hasError) {
          return SizedBox();
        } else {
          return SizedBox();
        }
      },
    );
  }

  Future<Widget> _loadPainter() async {
    final ByteData animationData = await rootBundle.load("assets/animations/like.json");
    final likeAnimation = await LottieComposition.fromByteData(animationData);

    return _AgoraLikeAnimationView(animation: likeAnimation, iconSize: iconSize);
  }
}

class _AgoraLikeAnimationView extends StatefulWidget {
  final double _iconSize;
  final LottieDrawable _drawable;

  _AgoraLikeAnimationView({
    required LottieComposition animation,
    required double iconSize,
  })  : _drawable = LottieDrawable(animation),
        _iconSize = iconSize;

  @override
  State<StatefulWidget> createState() {
    return _AgoraLikeAnimationViewState();
  }
}

class _AgoraLikeAnimationViewState extends State<_AgoraLikeAnimationView> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..repeat(reverse: false);

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _AgoraLikePainter(
        iconSize: widget._iconSize,
        drawable: widget._drawable,
        progress: _controller.value,
      ),
      size: Size.zero,
    );
  }
}

class _AgoraLikePainter extends CustomPainter {
  final double iconSize;
  final LottieDrawable drawable;
  final double progress;

  _AgoraLikePainter({required this.iconSize, required this.drawable, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    drawable
      ..setProgress(progress)
      ..draw(canvas, Rect.fromLTRB(-10, -28, iconSize * 3, iconSize * 3));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
