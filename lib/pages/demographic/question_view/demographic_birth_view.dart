import 'package:agora/common/strings/demographic_strings.dart';
import 'package:agora/design/custom_view/agora_text_field.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/demographic/demographic_helper.dart';
import 'package:flutter/material.dart';

class DemographicBirthView extends StatefulWidget {
  final Function(String) onContinuePressed;
  final VoidCallback onIgnorePressed;
  final TextEditingController? controller;

  const DemographicBirthView({
    super.key,
    required this.onContinuePressed,
    required this.onIgnorePressed,
    this.controller,
  });

  @override
  State<DemographicBirthView> createState() => _DemographicBirthViewState();
}

class _DemographicBirthViewState extends State<DemographicBirthView> {
  String? year;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    year = widget.controller?.text;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: AgoraTextField(
            hintText: DemographicStrings.yearOfBirthHint,
            controller: widget.controller,
            textInputType: TextFieldInputType.number,
            maxLength: 4,
            error: isError,
            onChanged: (String inputYear) {
              setState(() {
                isError = false;
                year = inputYear;
              });
            },
          ),
        ),
        if (isError) ...[
          SizedBox(height: AgoraSpacings.x0_75),
          Text(
            DemographicStrings.yearOfBirthError,
            style: AgoraTextStyles.light14.copyWith(color: AgoraColors.fluorescentRed),
          ),
        ],
        SizedBox(height: AgoraSpacings.x1_25),
        if (year != null && year!.length == 4)
          AgoraButton(
            label: DemographicStrings.continu,
            style: AgoraButtonStyle.primaryButtonStyle,
            onPressed: () {
              setState(() {
                isError = !_isBirthDateValid();
                if (!isError) {
                  widget.onContinuePressed(year!);
                }
              });
            },
          )
        else
          DemographicHelper.buildIgnoreButton(onPressed: widget.onIgnorePressed),
      ],
    );
  }

  bool _isBirthDateValid() {
    if (year != null) {
      try {
        final yearInt = int.parse(year!);
        if (yearInt >= 1900 && yearInt <= DateTime.now().year) {
          return true;
        }
      } on FormatException {
        return false;
      }
    }
    return false;
  }
}
