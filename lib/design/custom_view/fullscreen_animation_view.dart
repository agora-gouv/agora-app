import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class FullscreenAnimationView extends StatefulWidget {
  final Widget child;
  final String animationName;
  final int startDelayMillis;
  final double animationSpeed;

  const FullscreenAnimationView({
    super.key,
    required this.child,
    required this.animationName,
    this.startDelayMillis = 0,
    this.animationSpeed = 1.0,
  });

  @override
  State<FullscreenAnimationView> createState() => _FullscreenAnimationViewState();
}

class _FullscreenAnimationViewState extends State<FullscreenAnimationView> with TickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isAnimating = true;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    _controller.addListener(() {
      if (!_controller.isAnimating) {
        setState(() {
          _isAnimating = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAnimating) {
      return widget.child;
    }

    return Stack(
      children: [
        widget.child,
        IgnorePointer(
          ignoring: true,
          child: Lottie.asset(
            widget.animationName,
            controller: _controller,
            onLoaded: (composition) {
              final animationDuration = Duration(
                milliseconds: (composition.duration.inMilliseconds.toDouble() / widget.animationSpeed).round(),
              );

              Future.delayed(
                Duration(milliseconds: widget.startDelayMillis),
                () async {
                  _controller
                    ..duration = animationDuration
                    ..forward();
                },
              );
            },
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            repeat: false,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
