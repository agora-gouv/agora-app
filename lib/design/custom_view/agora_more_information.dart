import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgoraMoreInformation extends StatelessWidget {
  final String? semanticsLabel;
  final VoidCallback onClick;

  const AgoraMoreInformation({super.key, this.semanticsLabel, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticsLabel ?? SemanticsStrings.moreInformation,
      child: InkWell(
        onTap: () => onClick(),
        child: Padding(
          padding: const EdgeInsets.all(AgoraSpacings.x0_5),
          child: SvgPicture.asset("assets/ic_info.svg", excludeFromSemantics: true),
        ),
      ),
    );
  }
}
