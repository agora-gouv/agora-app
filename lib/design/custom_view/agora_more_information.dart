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
        borderRadius: BorderRadius.circular(20.0),
        onTap: () => onClick(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 44, minWidth: 44),
          child: Padding(
            padding: const EdgeInsets.all(AgoraSpacings.x0_75),
            child: SvgPicture.asset("assets/ic_info.svg", excludeFromSemantics: true),
          ),
        ),
      ),
    );
  }
}
