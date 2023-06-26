import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AgoraCollapseStyle { noRadius, withRadius }

class AgoraCollapseView extends StatefulWidget {
  final String title;
  final Widget collapseContent;
  final AgoraCollapseStyle style;

  const AgoraCollapseView({
    super.key,
    required this.title,
    required this.collapseContent,
    this.style = AgoraCollapseStyle.noRadius,
  });

  @override
  State<AgoraCollapseView> createState() => _AgoraCollapseViewState();
}

class _AgoraCollapseViewState extends State<AgoraCollapseView> {
  bool isCollapse = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.style == AgoraCollapseStyle.noRadius
          ? BorderRadius.all(AgoraCorners.noRound)
          : BorderRadius.all(AgoraCorners.rounded),
      child: Material(
        color: AgoraColors.transparent,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: widget.style == AgoraCollapseStyle.noRadius
                  ? BorderRadius.all(AgoraCorners.noRound)
                  : isCollapse
                      ? BorderRadius.vertical(top: AgoraCorners.rounded)
                      : BorderRadius.all(AgoraCorners.rounded),
              child: Material(
                color: AgoraColors.transparent,
                child: InkWell(
                  onTap: () => setState(() => isCollapse = !isCollapse),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AgoraSpacings.horizontalPadding,
                      vertical: AgoraSpacings.x0_5,
                    ),
                    child: _buildTitle(),
                  ),
                ),
              ),
            ),
            if (isCollapse) widget.collapseContent,
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        Expanded(child: Text(widget.title, style: AgoraTextStyles.medium16.copyWith(height: 0))),
        SizedBox(width: AgoraSpacings.base),
        isCollapse
            ? SvgPicture.asset("assets/ic_togglable_bottom.svg")
            : SvgPicture.asset("assets/ic_togglable_right.svg"),
      ],
    );
  }
}
