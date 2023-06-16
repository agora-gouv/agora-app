import 'package:flutter/material.dart';

class AgoraSingleScrollView extends StatelessWidget {
  final ScrollController? scrollController;
  final ScrollPhysics? physics;
  final Widget child;

  const AgoraSingleScrollView({
    Key? key,
    this.scrollController,
    this.physics,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          controller: scrollController,
          physics: physics,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(child: child),
          ),
        );
      },
    );
  }
}
