import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Future<T?> showAgoraDialog<T>({
  required BuildContext context,
  required List<Widget> columnChildren,
  bool dismissible = true,
}) {
  return showDialog(
    context: context,
    barrierDismissible: dismissible,
    builder: (context) {
      return Dialog(
        surfaceTintColor: AgoraColors.transparent,
        backgroundColor: AgoraColors.background,
        insetPadding: const EdgeInsets.all(AgoraSpacings.horizontalPadding),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(AgoraCorners.rounded12)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AgoraSpacings.x1_75,
                  vertical: AgoraSpacings.x1_25,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: columnChildren,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, right: 8),
                  child: _CrossButton(
                    onTap: () => Navigator.pop(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _CrossButton extends StatelessWidget {
  final void Function()? onTap;

  const _CrossButton({
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: "Fermer la fenêtre",
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(40),
        child: InkWell(
          splashColor: AgoraColors.neutral400,
          highlightColor: AgoraColors.neutral400,
          borderRadius: BorderRadius.circular(40),
          onTap: onTap,
          child: SizedBox(
            width: 48,
            height: 48,
            child: Center(
              child: SvgPicture.asset(
                'assets/ic_close.svg',
                excludeFromSemantics: true,
                alignment: Alignment.centerRight,
                height: 12,
                width: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
