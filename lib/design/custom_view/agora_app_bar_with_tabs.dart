import 'package:agora/design/agora_colors.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:agora/design/agora_text_styles.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/custom_view/agora_top_diagonal.dart';
import 'package:flutter/material.dart';

class AgoraAppBarWithTabs extends StatefulWidget {
  final TabController tabController;
  final Widget topChild;
  final List<Widget> tabChild;
  final bool needTopDiagonal;
  final bool needToolbar;

  AgoraAppBarWithTabs({
    required this.topChild,
    required this.tabChild,
    required this.tabController,
    this.needTopDiagonal = true,
    this.needToolbar = false,
  });

  @override
  State<AgoraAppBarWithTabs> createState() => _AgoraAppBarWithTabsState();
}

class _AgoraAppBarWithTabsState extends State<AgoraAppBarWithTabs> {
  final GlobalKey _backBarChildKey = GlobalKey();
  final GlobalKey _contentChildKey = GlobalKey();
  bool isHeightCalculated = false;
  double height = kToolbarHeight;

  @override
  Widget build(BuildContext context) {
    // calculate dynamically the toolbar size
    _buildToolbarHeightOnCreation(context);
    return SliverAppBar(
      pinned: true,
      floating: true,
      automaticallyImplyLeading: false,
      backgroundColor: AgoraColors.white,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.needTopDiagonal) AgoraTopDiagonal(),
            if (widget.needToolbar) AgoraToolbar(key: _backBarChildKey),
            NotificationListener<SizeChangedLayoutNotification>(
              onNotification: (notification) {
                _buildToolbarSizeOnContentChanged(context);
                return false;
              },
              child: SizeChangedLayoutNotifier(
                child: Padding(
                  key: _contentChildKey,
                  padding: widget.needToolbar == true
                      ? EdgeInsets.symmetric(horizontal: AgoraSpacings.base)
                      : EdgeInsets.only(left: AgoraSpacings.base, right: AgoraSpacings.base, top: AgoraSpacings.base),
                  child: widget.topChild,
                ),
              ),
            ),
          ],
        ),
      ),
      toolbarHeight: height,
      bottom: TabBar(
        controller: widget.tabController,
        indicatorColor: AgoraColors.blueFrance,
        labelStyle: AgoraTextStyles.medium14,
        unselectedLabelStyle: AgoraTextStyles.light14,
        labelColor: AgoraColors.primaryGrey,
        unselectedLabelColor: AgoraColors.primaryGrey,
        tabs: widget.tabChild,
      ),
    );
  }

  void _buildToolbarHeightOnCreation(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!isHeightCalculated) {
        _calculateToolbarHeight(context);
      }
    });
  }

  void _buildToolbarSizeOnContentChanged(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _calculateToolbarHeight(context);
    });
  }

  void _calculateToolbarHeight(BuildContext context) {
    final contentHeight = (_contentChildKey.currentContext?.findRenderObject() as RenderBox).size.height;
    const addSpacingBetweenContentAndTabBar = AgoraSpacings.base;
    setState(() {
      isHeightCalculated = true;
      height = contentHeight;
      if (widget.needTopDiagonal) {
        final topDiagonalHeight = MediaQuery.of(context).size.height * 0.02;
        height = height + topDiagonalHeight;
      }
      if (widget.needToolbar) {
        final backBarHeight = (_backBarChildKey.currentContext?.findRenderObject() as RenderBox).size.height;
        height = height + backBarHeight;
      }
      height = height + addSpacingBetweenContentAndTabBar;
    });
  }
}

class TopDiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final diagonalPath = Path();
    const double initialX = 0;
    const double initialY = 0;
    diagonalPath.lineTo(initialX, initialY);
    diagonalPath.lineTo(initialX, size.height);
    diagonalPath.lineTo(size.width, size.height * 0.5);
    diagonalPath.lineTo(size.width, initialY);
    return diagonalPath;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
