import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class AgoraLikeAnimationView extends StatelessWidget {
  final GlobalKey<AgoraAnimatedLikeViewState> animationControllerKey;

  const AgoraLikeAnimationView({required this.animationControllerKey});

  void notifyDisplayRectAvailable(Rect displayRect) async {
    if (animationControllerKey.currentState != null) {
      animationControllerKey.currentState?.setDisplayRect(displayRect);
    } else {
      Future.delayed(Duration(milliseconds: 100), () {
        notifyDisplayRectAvailable(displayRect);
      });
    }
  }

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

    return _AgoraAnimatedLikeView(key: animationControllerKey, animation: likeAnimation);
  }
}

class _AgoraAnimatedLikeView extends StatefulWidget {
  final LottieDrawable _drawable;

  _AgoraAnimatedLikeView({
    super.key,
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
  Rect _currentDisplayRect = Rect.fromLTRB(0, 0, 0, 0);
  Rect _likeDisplayRect = Rect.fromLTRB(0, 0, 0, 0);

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        _currentDisplayRect = Rect.fromLTWH(
          position.dx,
          position.dy,
          renderBox.size.width,
          renderBox.size.height,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void setDisplayRect(Rect displayRect) {
    _likeDisplayRect = displayRect;
  }

  void startAnimation() {
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final targetRect = _buildTargetRect();
    return CustomPaint(
      painter: _AgoraLikePainter(
        drawable: widget._drawable,
        displayRect: Rect.fromLTRB(
          targetRect.left - _currentDisplayRect.left,
          targetRect.top - _currentDisplayRect.top,
          targetRect.right - _currentDisplayRect.left,
          targetRect.bottom - _currentDisplayRect.top,
        ),
        isAnimating: _controller.isAnimating,
        progress: _controller.value,
      ),
      size: Size.zero,
    );
  }

  Rect _buildTargetRect() {
    final width = _likeDisplayRect.right - _likeDisplayRect.left;
    final height = _likeDisplayRect.bottom - _likeDisplayRect.top;

    final targetWidth = width * 3.8;
    final targetHeight = height * 3.8;

    return Rect.fromLTWH(
      _likeDisplayRect.left - (targetWidth - width) / 2,
      _likeDisplayRect.top - (targetHeight - height) / 2,
      targetWidth,
      targetHeight,
    );
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
