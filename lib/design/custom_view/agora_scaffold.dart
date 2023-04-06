import 'package:agora/design/agora_colors.dart';
import 'package:flutter/material.dart';

class AgoraScaffold extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final bool shouldPop;
  final VoidCallback? popAction;

  const AgoraScaffold({
    super.key,
    this.backgroundColor = AgoraColors.white,
    required this.child,
    this.shouldPop = true,
    this.popAction,
  });

  @override
  Widget build(BuildContext context) {
    if (shouldPop) {
      if (popAction != null) {
        return WillPopScope(
          onWillPop: () async {
            popAction!();
            return true;
          },
          child: _buildScaffold(),
        );
      } else {
        return _buildScaffold();
      }
    } else {
      return WillPopScope(onWillPop: () async => false, child: _buildScaffold());
    }
  }

  Scaffold _buildScaffold() {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: child,
    );
  }
}
