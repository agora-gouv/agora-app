import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/helper/semantics_helper.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
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
  final int? minLines;
  final Function(String input)? onChanged;
  final TextFieldIcon? rightIcon;
  final bool check;
  final bool error;
  final bool blockToMaxLength;
  final String? contentDescription;
  final FocusNode? focusNode;

  AgoraTextField({
    super.key,
    this.hintText,
    this.textInputAction,
    this.controller,
    this.showCounterText = false,
    this.maxLength = 400,
    this.maxLines = 50,
    this.onChanged,
    this.rightIcon,
    this.minLines,
    this.check = false,
    this.error = false,
    this.blockToMaxLength = false,
    this.textInputType = TextFieldInputType.multiline,
    this.contentDescription,
    this.focusNode,
  });

  @override
  State<AgoraTextField> createState() => _AgoraTextFieldState();
}

class _AgoraTextFieldState extends State<AgoraTextField> {
  int textCount = 0;
  bool _tooMuchInput = false;

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
            side: widget.error || _tooMuchInput
                ? BorderSide(color: AgoraColors.fluorescentRed, width: 2)
                : widget.check
                    ? BorderSide(color: AgoraColors.primaryBlue, width: 1)
                    : BorderSide(color: AgoraColors.borderHintColor, width: 1),
          ),
          child: Stack(
            alignment: AlignmentDirectional.centerEnd,
            children: [
              Padding(
                padding: widget.rightIcon == TextFieldIcon.search
                    ? EdgeInsets.only(right: AgoraSpacings.x2)
                    : EdgeInsets.zero,
                child: Semantics(
                  textField: true,
                  label: widget.contentDescription,
                  tooltip:
                      "${_tooMuchInput ? 'Limite de caractères dépassée : ' : 'Limite de caractères : '}${SemanticsHelper.step(textCount, widget.maxLength)}",
                  child: ExcludeSemantics(
                    child: TextField(
                      focusNode: widget.focusNode,
                      minLines: widget.minLines ?? 1,
                      maxLines: widget.textInputType == TextFieldInputType.multiline ? widget.maxLines : 1,
                      scrollPadding: const EdgeInsets.only(bottom: AgoraSpacings.x3 * 3),
                      textCapitalization: TextCapitalization.sentences,
                      maxLength: widget.blockToMaxLength || widget.textInputType == TextFieldInputType.number
                          ? widget.maxLength
                          : widget.maxLength * 2,
                      controller: widget.controller,
                      inputFormatters: _buildTextInputFormatter(),
                      keyboardType: _buildTextInputType(),
                      style: AgoraTextStyles.light14,
                      textInputAction: widget.textInputAction,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(AgoraSpacings.base),
                        border: UnderlineInputBorder(borderSide: BorderSide.none),
                        hintText: widget.hintText,
                        hintStyle: AgoraTextStyles.light14.copyWith(color: AgoraColors.hintColor),
                        counterText: "",
                      ),
                      onChanged: (String input) {
                        setState(() {
                          _tooMuchInput = input.length > widget.maxLength;
                          textCount = input.length;
                        });
                        widget.onChanged?.call(input);

                        final announceCharNumber = 0.9 * widget.maxLength;
                        if (textCount == announceCharNumber) {
                          final remainingCharNumber = widget.maxLength - announceCharNumber;
                          SemanticsService.announce(
                            SemanticsStrings.remainingChar.format(remainingCharNumber.toInt().toString()),
                            TextDirection.ltr,
                          );
                        } else if (textCount == widget.maxLength) {
                          SemanticsService.announce(SemanticsStrings.maxCharAttempt, TextDirection.ltr);
                        }
                      },
                    ),
                  ),
                ),
              ),
              if (widget.rightIcon == TextFieldIcon.search) ...[
                Padding(
                  padding: const EdgeInsets.only(right: AgoraSpacings.base),
                  child: SvgPicture.asset("assets/ic_search.svg", excludeFromSemantics: true),
                ),
              ],
            ],
          ),
        ),
        if (widget.showCounterText) ...[
          SizedBox(height: AgoraSpacings.x0_25),
          ExcludeSemantics(
            child: Text(
              "${_tooMuchInput ? 'Limite de caractères dépassée : ' : ''}$textCount/${widget.maxLength}",
              style: AgoraTextStyles.light12
                  .copyWith(color: _tooMuchInput ? AgoraColors.fluorescentRed : AgoraColors.primaryGreyOpacity70),
            ),
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
