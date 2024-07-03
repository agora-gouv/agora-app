import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgoraMenuItem extends StatelessWidget {
  final String title;
  final bool isExternalRedirect;
  final VoidCallback onClick;

  const AgoraMenuItem({
    super.key,
    required this.title,
    this.isExternalRedirect = false,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: InkWell(
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
              if (isExternalRedirect) ...[
                Expanded(
                  child: RichText(
                    textScaler: MediaQuery.textScalerOf(context),
                    text: TextSpan(
                      children: [
                        TextSpan(text: title, style: AgoraTextStyles.regular18),
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 2, left: 4),
                            child: SvgPicture.asset(
                              'assets/ic_external_link.svg',
                              excludeFromSemantics: true,
                              height: 20,
                              width: 20,
                              colorFilter: const ColorFilter.mode(AgoraColors.primaryGrey, BlendMode.srcIn),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SvgPicture.asset("assets/ic_next.svg", excludeFromSemantics: true),
              ] else ...[
                Expanded(child: Text(title, style: AgoraTextStyles.regular18)),
                SvgPicture.asset("assets/ic_next.svg", excludeFromSemantics: true),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
