import 'package:agora/design/style/agora_colors.dart';
import 'package:flutter/material.dart';

class AgoraTopDiagonal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TopDiagonalClipper(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.02,
        color: AgoraColors.primaryGreen,
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
