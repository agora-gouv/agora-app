import 'package:agora/common/strings/demographic_strings.dart';
import 'package:agora/design/custom_view/agora_text_field.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/demographic/demographic_helper.dart';
import 'package:flutter/material.dart';

class DemographicBirthView extends StatefulWidget {
  final int step;
  final int totalStep;
  final Function(String) onContinuePressed;
  final VoidCallback onIgnorePressed;
  final VoidCallback onBackPressed;
  final TextEditingController? controller;

  const DemographicBirthView({
    super.key,
    required this.step,
    required this.totalStep,
    required this.onContinuePressed,
    required this.onIgnorePressed,
    required this.onBackPressed,
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            DemographicHelper.buildBackButton(step: widget.step, onBackTap: widget.onBackPressed),
            const SizedBox(width: AgoraSpacings.base),
            Flexible(
              child: year != null && year!.length == 4
                  ? DemographicHelper.buildNextButton(
                      step: widget.step,
                      totalStep: widget.totalStep,
                      onPressed: () => setState(() {
                        isError = !_isBirthDateValid();
                        if (!isError) {
                          widget.onContinuePressed(year!);
                        }
                      }),
                    )
                  : DemographicHelper.buildIgnoreButton(onPressed: widget.onIgnorePressed),
            ),
          ],
        ),
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
