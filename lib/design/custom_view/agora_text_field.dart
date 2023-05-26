import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum TextFieldInputType { number, multiline }

enum TextFieldIcon { search }

class AgoraTextField extends StatefulWidget {
  final String? hintText;
  final TextFieldInputType textInputType;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final bool showCounterText;
  final int maxLength;
  final int maxLines;
  final Function(String input)? onChanged;
  final TextFieldIcon? rightIcon;
  final bool check;
  final bool error;

  AgoraTextField({
    this.hintText,
    this.textInputAction,
    this.controller,
    this.showCounterText = false,
    this.maxLength = 400,
    this.maxLines = 50,
    this.onChanged,
    this.rightIcon,
    this.check = false,
    this.error = false,
    this.textInputType = TextFieldInputType.multiline,
  });

  @override
  State<AgoraTextField> createState() => _AgoraTextFieldState();
}

class _AgoraTextFieldState extends State<AgoraTextField> {
  int textCount = 0;

  @override
  void initState() {
    super.initState();
    final controller = widget.controller;
    if (controller != null) {
      textCount = controller.text.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Material(
          clipBehavior: Clip.antiAlias,
          color: AgoraColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(AgoraCorners.rounded),
            side: widget.error
                ? BorderSide(color: AgoraColors.fluorescentRed, width: 2)
                : widget.check
                    ? BorderSide(color: AgoraColors.primaryBlue, width: 1)
                    : BorderSide(color: AgoraColors.border, width: 1),
          ),
          child: Stack(
            alignment: AlignmentDirectional.centerEnd,
            children: [
              Padding(
                padding: widget.rightIcon == TextFieldIcon.search
                    ? EdgeInsets.only(right: AgoraSpacings.x2)
                    : EdgeInsets.zero,
                child: TextField(
                  minLines: 1,
                  maxLines: widget.textInputType == TextFieldInputType.multiline ? widget.maxLines : 1,
                  scrollPadding: const EdgeInsets.only(bottom: AgoraSpacings.x3 * 3),
                  maxLength: widget.maxLength,
                  controller: widget.controller,
                  inputFormatters: _buildTextInputFormatter(),
                  keyboardType: _buildTextInputType(),
                  style: AgoraTextStyles.light14,
                  textInputAction: widget.textInputAction,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(AgoraSpacings.base),
                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                    hintText: widget.hintText,
                    hintStyle: AgoraTextStyles.light14.copyWith(color: AgoraColors.orochimaru),
                    counterText: "",
                  ),
                  onChanged: (String input) {
                    setState(() => textCount = input.length);
                    widget.onChanged?.call(input);
                  },
                ),
              ),
              if (widget.rightIcon == TextFieldIcon.search) ...[
                Padding(
                  padding: const EdgeInsets.only(right: AgoraSpacings.base),
                  child: SvgPicture.asset("assets/ic_search.svg"),
                ),
              ]
            ],
          ),
        ),
        if (widget.showCounterText) ...[
          SizedBox(height: AgoraSpacings.x0_25),
          Text(
            " $textCount/${widget.maxLength}",
            style: AgoraTextStyles.light12.copyWith(color: AgoraColors.primaryGreyOpacity70),
          ),
        ],
      ],
    );
  }

  TextInputType _buildTextInputType() {
    switch (widget.textInputType) {
      case TextFieldInputType.multiline:
        return TextInputType.multiline;
      case TextFieldInputType.number:
        return TextInputType.numberWithOptions(signed: false, decimal: false);
    }
  }

  List<TextInputFormatter>? _buildTextInputFormatter() {
    switch (widget.textInputType) {
      case TextFieldInputType.number:
        return [FilteringTextInputFormatter.digitsOnly];
      case TextFieldInputType.multiline:
        return null;
    }
  }
}
