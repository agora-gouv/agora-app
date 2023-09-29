import 'package:flutter/material.dart';

class AgoraRoundedImage extends StatelessWidget {
  final String imageUrl;
  final double size;

  AgoraRoundedImage({required this.imageUrl, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
