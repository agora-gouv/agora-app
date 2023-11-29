import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class AgoraLikeAnimationView extends StatelessWidget {
  const AgoraLikeAnimationView();

  void animate() {
    debugPrint("Should animate like button !!");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_AgoraLikeAnimationView>(
      future: _loadPainter(),
      builder: (BuildContext context, AsyncSnapshot<_AgoraLikeAnimationView> snapshot) {
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

  Future<_AgoraLikeAnimationView> _loadPainter() async {
    final ByteData animationData = await rootBundle.load("assets/animations/like.json");
    final likeAnimation = await LottieComposition.fromByteData(animationData);

    return _AgoraLikeAnimationView(animation: likeAnimation);
  }
}

class _AgoraLikeAnimationView extends StatefulWidget {
  final LottieDrawable _drawable;

  _AgoraLikeAnimationView({required LottieComposition animation}) : _drawable = LottieDrawable(animation);

  @override
  State<StatefulWidget> createState() {
    return _AgoraLikeAnimationViewState();
  }
}

class _AgoraLikeAnimationViewState extends State<_AgoraLikeAnimationView> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..forward();

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
        iconSize: 18, // FIXME
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
    if (progress < 1) {
      drawable
        ..setProgress(progress)
        ..draw(canvas, Rect.fromLTRB(0, 0, iconSize * 2.5, iconSize * 2.5)); // FIXME dimensions
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
