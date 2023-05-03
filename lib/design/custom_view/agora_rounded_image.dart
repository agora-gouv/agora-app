import 'package:flutter/material.dart';

class AgoraRoundedImage extends StatelessWidget {
  final String imageUrl;

  AgoraRoundedImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 27,
      height: 27,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
