import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

enum AgoraTrimMode {
  length,
  line,
}

class AgoraReadMoreText extends StatefulWidget {
  final String data;
  final int trimLines;
  final TextStyle style;
  final TextAlign textAlign;
  final bool isTalkbackEnabled;
  final Color backgroundColor;

  const AgoraReadMoreText({
    super.key,
    required this.data,
    required this.isTalkbackEnabled,
    this.backgroundColor = Colors.white,
    this.trimLines = 5,
    this.style = AgoraTextStyles.light14,
    this.textAlign = TextAlign.justify,
  });

  @override
  AgoraReadMoreTextState createState() => AgoraReadMoreTextState();
}

class AgoraReadMoreTextState extends State<AgoraReadMoreText> {
  bool _isExpanded = false;

  @override
  void initState() {
    _isExpanded = false || widget.isTalkbackEnabled;
    super.initState();
  }

  void _onReadMoreLink() {
    setState(() => _isExpanded = !_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Text(
              widget.data,
              style: widget.style,
              textAlign: widget.textAlign,
              maxLines: _isExpanded ? null : widget.trimLines,
            ),
            if (!_isExpanded)
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: AgoraSpacings.x2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [widget.backgroundColor.withOpacity(0), widget.backgroundColor],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AgoraSpacings.x0_5),
        ShowMoreButton(
          onTap: _onReadMoreLink,
          label: _isExpanded ? 'Lire moins' : 'Lire la suite',
          horizontalPadding: 0,
        ),
      ],
    );
  }
}

class ShowMoreButton extends StatelessWidget {
  final void Function() onTap;
  final String label;
  final double horizontalPadding;

  ShowMoreButton({
    required this.onTap,
    this.label = 'Lire la suite',
    this.horizontalPadding = AgoraSpacings.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AgoraSpacings.x0_5, horizontal: horizontalPadding),
        child: AgoraButton(
          label: label,
          buttonStyle: AgoraButtonStyle.blueBorder,
          onPressed: onTap,
        ),
      ),
    );
  }
}
