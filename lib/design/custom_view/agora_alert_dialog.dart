import 'package:agora/design/agora_corners.dart';
import 'package:flutter/material.dart';

Future<T?> showAgoraDialog<T>({
  required BuildContext context,
  required List<Widget> columnChildren,
  bool dismissible = false,
}) {
  return showDialog(
    context: context,
    barrierDismissible: dismissible,
    builder: (context) {
      return AlertDialog(
        scrollable: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(AgoraCorners.rounded)),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: columnChildren,
        ),
      );
    },
  );
}
