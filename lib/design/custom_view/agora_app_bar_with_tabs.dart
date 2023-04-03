import 'package:flutter/material.dart';
import 'package:agora/design/agora_colors.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:agora/design/agora_text_styles.dart';

class AgoraAppBarWithTabs extends StatelessWidget {
  final TabController tabController;
  final double toolbarHeight;
  final Widget topChild;
  final List<Widget> tabChild;

  AgoraAppBarWithTabs({
    required this.topChild,
    required this.tabChild,
    required this.tabController,
    this.toolbarHeight = kToolbarHeight,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      automaticallyImplyLeading: false,
      backgroundColor: AgoraColors.white,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipPath(
              clipper: TopDiagonalClipper(),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.02,
                color: AgoraColors.primaryGreen,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: AgoraSpacings.base,
                top: AgoraSpacings.base,
                right: AgoraSpacings.base,
              ),
              child: topChild,
            ),
          ],
        ),
      ),
      toolbarHeight: toolbarHeight,
      bottom: TabBar(
        controller: tabController,
        indicatorColor: AgoraColors.blueFrance,
        labelStyle: AgoraTextStyles.medium14,
        unselectedLabelStyle: AgoraTextStyles.light14,
        labelColor: AgoraColors.primaryGrey,
        unselectedLabelColor: AgoraColors.primaryGrey,
        tabs: tabChild,
      ),
    );
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
