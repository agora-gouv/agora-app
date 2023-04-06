import 'package:agora/string/generic_strings.dart';
import 'package:flutter/material.dart';

class AgoraErrorView extends StatelessWidget {
  final String errorMessage;

  const AgoraErrorView({super.key, this.errorMessage = GenericStrings.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Text(errorMessage);
  }
}
