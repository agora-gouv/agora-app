import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomeCard extends StatelessWidget {
  final Color backgroundColor;
  final String iconPath;
  final ColorFilter? iconColorFilter;
  final List<TextSpan> textContent;
  final void Function() onTap;
  final bool isDarkCard;

  const WelcomeCard({
    this.backgroundColor = AgoraColors.white,
    required this.iconPath,
    this.iconColorFilter,
    required this.textContent,
    required this.onTap,
    this.isDarkCard = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            highlightColor: AgoraColors.neutral200,
            hoverColor: AgoraColors.neutral200,
            focusColor: isDarkCard ? AgoraColors.rhineCastle : AgoraColors.neutral200,
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(AgoraSpacings.x1_25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    iconPath,
                    colorFilter: iconColorFilter,
                    width: 40,
                    height: 40,
                    excludeFromSemantics: true,
                  ),
                  SizedBox(width: AgoraSpacings.base),
                  Expanded(
                    child: RichText(
                      textScaler: MediaQuery.textScalerOf(context),
                      text: TextSpan(
                        children: textContent,
                      ),
                    ),
                  ),
                  SizedBox(width: AgoraSpacings.x0_75),
                  SvgPicture.asset(
                    "assets/ic_chevrons.svg",
                    colorFilter: iconColorFilter,
                    width: 15,
                    height: 15,
                    excludeFromSemantics: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
