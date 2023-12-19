import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class AgoraLikeAnimationView extends StatelessWidget {
  final GlobalKey<AgoraAnimatedLikeViewState> animationControllerKey;
  final GlobalKey likeViewKey;

  const AgoraLikeAnimationView({
    required this.animationControllerKey,
    required this.likeViewKey,
  });

  void animate() {
    animationControllerKey.currentState?.startAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_AgoraAnimatedLikeView>(
      future: _loadPainter(),
      builder: (BuildContext context, AsyncSnapshot<_AgoraAnimatedLikeView> snapshot) {
        if (snapshot.hasData) {
          return snapshot.data ?? SizedBox();
        } else if (snapshot.hasError) {
          return SizedBox();
        } else {
          return SizedBox();
        }
      },
    );
  }

  Future<_AgoraAnimatedLikeView> _loadPainter() async {
    final ByteData animationData = await rootBundle.load("assets/animations/like.json");
    final likeAnimation = await LottieComposition.fromByteData(animationData);

    return _AgoraAnimatedLikeView(key: animationControllerKey, likeViewKey: likeViewKey, animation: likeAnimation);
  }
}

class _AgoraAnimatedLikeView extends StatefulWidget {
  final GlobalKey likeViewKey;
  final LottieDrawable _drawable;

  _AgoraAnimatedLikeView({
    super.key,
    required this.likeViewKey,
    required LottieComposition animation,
  }) : _drawable = LottieDrawable(animation);

  @override
  State<StatefulWidget> createState() {
    return AgoraAnimatedLikeViewState();
  }
}

class AgoraAnimatedLikeViewState extends State<_AgoraAnimatedLikeView> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 750),
    vsync: this,
  );

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

  void startAnimation() {
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _AgoraLikePainter(
        drawable: widget._drawable,
        displayRect: _buildTargetRect(),
        isAnimating: _controller.isAnimating,
        progress: _controller.value,
      ),
      size: Size.zero,
    );
  }

  Rect _buildTargetRect() {
    final currentDisplayRect = _buildRect(context);
    final likeDisplayRect = _buildRect(widget.likeViewKey.currentContext);

    final likeWidth = likeDisplayRect.right - likeDisplayRect.left;
    final likeHeight = likeDisplayRect.bottom - likeDisplayRect.top;

    final targetAnimationWidth = likeWidth * 3.8;
    final targetAnimationHeight = likeHeight * 3.8;

    return Rect.fromLTWH(
      likeDisplayRect.left - (targetAnimationWidth - likeWidth) / 2 - currentDisplayRect.left,
      likeDisplayRect.top - (targetAnimationHeight - likeHeight) / 2 - currentDisplayRect.top,
      targetAnimationWidth,
      targetAnimationHeight,
    );
  }

  Rect _buildRect(BuildContext? context) {
    if (context != null && context.findRenderObject() != null) {
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      return Rect.fromLTWH(
        position.dx,
        position.dy,
        renderBox.size.width,
        renderBox.size.height,
      );
    } else {
      return Rect.fromLTRB(0, 0, 0, 0);
    }
  }
}

class _AgoraLikePainter extends CustomPainter {
  final LottieDrawable drawable;
  final Rect displayRect;
  final bool isAnimating;
  final double progress;

  _AgoraLikePainter({
    required this.drawable,
    required this.displayRect,
    required this.isAnimating,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (isAnimating) {
      drawable
        ..setProgress(progress)
        ..draw(canvas, displayRect);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
