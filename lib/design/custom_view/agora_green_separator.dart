import 'package:agora/design/style/agora_colors.dart';
import 'package:flutter/material.dart';

class AgoraGreenSeparator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AgoraColors.primaryGreen,
      height: 3,
      width: MediaQuery.of(context).size.width * 0.15,
    );
  }
}
