import 'package:agora/design/custom_view/agora_responsive_view.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AgoraScaffold extends StatelessWidget {
  final Widget child;
  final Color appBarColor;
  final Color backgroundColor;
  final bool shouldPop;
  final bool Function()? popAction;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const AgoraScaffold({
    super.key,
    this.appBarColor = AgoraColors.white,
    this.backgroundColor = AgoraColors.white,
    required this.child,
    this.shouldPop = true,
    this.popAction,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  @override
  Widget build(BuildContext context) {
    if (shouldPop) {
      if (popAction != null) {
        return WillPopScope(
          onWillPop: () async {
            return popAction!();
          },
          child: _build(),
        );
      } else {
        return _build();
      }
    } else {
      return WillPopScope(onWillPop: () async => false, child: _build());
    }
  }

  Widget _build() {
    if (kIsWeb) {
      return AgoraResponsiveView(child: _buildScaffold());
    } else {
      return _buildScaffold();
    }
  }

  Scaffold _buildScaffold() {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: child,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}
