import 'package:agora/design/style/agora_colors.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

ScrollDirection prevScrollDirection = ScrollDirection.idle;
const _indicatorSize = 80.0;

// ignore: must_be_immutable
class AgoraPullToRefresh extends StatelessWidget {
  final AsyncCallback onRefresh;
  final Widget child;
  final double paddingTop;
  final bool enabled;
  bool _isIdle = true;

  AgoraPullToRefresh({
    required this.onRefresh,
    required this.child,
    this.paddingTop = 0,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return enabled
        ? CustomRefreshIndicator(
            onRefresh: onRefresh,
            offsetToArmed: _indicatorSize,
            onStateChanged: (change) {
              _isIdle = change.currentState.isIdle;
            },
            builder: (BuildContext context, Widget child, IndicatorController controller) {
              return Stack(
                children: [
                  AnimatedBuilder(
                    animation: controller,
                    builder: (BuildContext context, Widget? _) {
                      prevScrollDirection = controller.scrollingDirection;

                      final containerHeight = controller.value * _indicatorSize;

                      if (_isIdle || controller.value < 0.15) {
                        return const SizedBox(height: 0);
                      } else {
                        return Padding(
                          padding: EdgeInsets.only(top: paddingTop),
                          child: Container(
                            alignment: Alignment.center,
                            height: containerHeight,
                            child: OverflowBox(
                              maxHeight: 40,
                              minHeight: 40,
                              maxWidth: 40,
                              minWidth: 40,
                              alignment: Alignment.center,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(color: AgoraColors.primaryBlue, shape: BoxShape.circle),
                                child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: const AlwaysStoppedAnimation(AgoraColors.white),
                                    value: controller.isDragging || controller.isArmed
                                        ? controller.value.clamp(0.0, 1.0)
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  AnimatedBuilder(
                    builder: (_, child) {
                      return Transform.translate(
                        offset: Offset(0.0, controller.value * _indicatorSize),
                        child: child,
                      );
                    },
                    animation: controller,
                    child: child,
                  ),
                ],
              );
            },
            child: child,
          )
        : child;
  }
}
