import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/strings/demographic_strings.dart';
import 'package:agora/design/custom_view/agora_checkbox.dart';
import 'package:agora/design/custom_view/agora_demographic_simple_view.dart';
import 'package:agora/design/custom_view/text/agora_text_field.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/profil/demographic/domain/demographic_response.dart';
import 'package:agora/profil/demographic/pages/helpers/demographic_helper.dart';
import 'package:agora/territorialisation/departement.dart';
import 'package:agora/territorialisation/territoire.dart';
import 'package:agora/territorialisation/territoire_helper.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class DemographicDepartmentView extends StatefulWidget {
  final int step;
  final int totalStep;
  final void Function(String responseCode) onContinuePressed;
  final VoidCallback onIgnorePressed;
  final VoidCallback onBackPressed;
  final DemographicResponse? oldResponse;
  final List<Territoire> territoires;

  const DemographicDepartmentView({
    super.key,
    required this.step,
    required this.totalStep,
    required this.onContinuePressed,
    required this.onIgnorePressed,
    required this.onBackPressed,
    required this.oldResponse,
    required this.territoires,
  });

  @override
  State<DemographicDepartmentView> createState() => _DemographicDepartmentViewState();
}

class _DemographicDepartmentViewState extends State<DemographicDepartmentView> {
  List<Departement> findDepartments = [];
  Departement? selectedDepartment;
  bool isFrancaisDeLEtranger = false;

  @override
  void initState() {
    super.initState();
    final oldCode = widget.oldResponse?.response;
    if (oldCode != null) {
      final oldDepartment = getDepartementByCodePostal(oldCode, widget.territoires);
      if (oldDepartment != null) {
        if (oldDepartment.codePostal == "99") {
          isFrancaisDeLEtranger = true;
        } else {
          selectedDepartment = oldDepartment;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AgoraTextField(
          hintText: DemographicStrings.departmentHint,
          rightIcon: TextFieldIcon.search,
          onChanged: (String input) {
            setState(() {
              if (input.isNotBlank()) {
                findDepartments = getDepartementFromReferentiel(widget.territoires)
                    .where(
                      (departement) => departement.displayLabel
                          .toLowerCase()
                          .removeDiacritics()
                          .removePunctuationMark()
                          .contains(input.toLowerCase().removeDiacritics().removePunctuationMark()),
                    )
                    .toList();
              } else {
                findDepartments = [];
              }
            });
          },
        ),
        SizedBox(height: AgoraSpacings.base),
        ...findDepartments.mapIndexed(
          (index, departement) => AgoraDemographicResponseCard(
            responseLabel: departement.displayLabel,
            isSelected: selectedDepartment == departement,
            onTap: () {
              setState(() {
                if (selectedDepartment != departement) {
                  isFrancaisDeLEtranger = false;
                  selectedDepartment = departement;
                } else {
                  selectedDepartment = null;
                }
              });
            },
            semantic: DemographicResponseCardSemantic(
              currentIndex: index + 1,
              totalIndex: findDepartments.length,
            ),
          ),
        ),
        if (selectedDepartment != null && !findDepartments.contains(selectedDepartment)) ...[
          AgoraDemographicResponseCard(
            responseLabel: selectedDepartment!.displayLabel,
            isSelected: true,
            onTap: () {
              setState(() {
                selectedDepartment = null;
              });
            },
            semantic: DemographicResponseCardSemantic(
              currentIndex: 1,
              totalIndex: findDepartments.length,
            ),
          ),
        ],
        _EtrangerCheckbox(
          isCheck: isFrancaisDeLEtranger,
          onCheckChanged: (checked) {
            if (checked) {
              setState(() {
                selectedDepartment = null;
                isFrancaisDeLEtranger = true;
              });
            } else {
              setState(() {
                isFrancaisDeLEtranger = false;
              });
            }
          },
        ),
        SizedBox(height: AgoraSpacings.x1_25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DemographicHelper.buildBackButton(step: widget.step, onBackTap: widget.onBackPressed),
            const SizedBox(width: AgoraSpacings.base),
            Flexible(
              child: selectedDepartment != null || isFrancaisDeLEtranger
                  ? DemographicHelper.buildNextButton(
                      step: widget.step,
                      totalStep: widget.totalStep,
                      onPressed: () => setState(() => widget.onContinuePressed(selectedDepartment?.codePostal ?? "99")),
                    )
                  : DemographicHelper.buildIgnoreButton(onPressed: widget.onIgnorePressed),
            ),
          ],
        ),
      ],
    );
  }
}

class _EtrangerCheckbox extends StatelessWidget {
  final bool isCheck;
  final void Function(bool) onCheckChanged;

  const _EtrangerCheckbox({
    required this.isCheck,
    required this.onCheckChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AgoraSpacings.x0_5,
        horizontal: AgoraSpacings.x0_375,
      ),
      child: AgoraCheckbox(
        value: isCheck,
        label: "J'habite à l'étranger",
        onChanged: onCheckChanged,
      ),
    );
  }
}
