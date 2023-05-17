import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgoraMenuItem extends StatelessWidget {
  final String title;
  final VoidCallback onClick;

  const AgoraMenuItem({
    super.key,
    required this.title,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.only(
          top: AgoraSpacings.base,
          bottom: AgoraSpacings.base,
          right: AgoraSpacings.horizontalPadding + AgoraSpacings.x0_75,
          left: AgoraSpacings.horizontalPadding,
        ),
        child: Row(
          children: [
            Expanded(child: Text(title, style: AgoraTextStyles.regular18)),
            SvgPicture.asset("assets/ic_next.svg"),
          ],
        ),
      ),
    );
  }
}
