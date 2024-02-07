import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/strings/demographic_strings.dart';
import 'package:agora/design/custom_view/agora_checkbox.dart';
import 'package:agora/design/custom_view/agora_demographic_simple_view.dart';
import 'package:agora/design/custom_view/agora_text_field.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/domain/demographic/demographic_response.dart';
import 'package:agora/domain/demographic/department.dart';
import 'package:agora/pages/demographic/demographic_helper.dart';
import 'package:flutter/material.dart';

class DemographicDepartmentView extends StatefulWidget {
  final int step;
  final int totalStep;
  final void Function(String responseCode) onContinuePressed;
  final VoidCallback onIgnorePressed;
  final VoidCallback onBackPressed;
  final DemographicResponse? oldResponse;

  const DemographicDepartmentView({
    super.key,
    required this.step,
    required this.totalStep,
    required this.onContinuePressed,
    required this.onIgnorePressed,
    required this.onBackPressed,
    required this.oldResponse,
  });

  @override
  State<DemographicDepartmentView> createState() => _DemographicDepartmentViewState();
}

class _DemographicDepartmentViewState extends State<DemographicDepartmentView> {
  List<Department> findDepartments = [];
  Department? selectedDepartment;

  @override
  void initState() {
    super.initState();
    final oldCode = widget.oldResponse?.response;
    if (oldCode != null) {
      final oldDepartment =
          DepartmentHelper.getDepartment().where((department) => department.code == oldCode).firstOrNull;
      if (oldDepartment != null) {
        selectedDepartment = oldDepartment;
        findDepartments = [oldDepartment];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _handleResponse(context),
    );
  }

  List<Widget> _handleResponse(BuildContext context) {
    final List<Widget> widgets = [
      AgoraTextField(
        hintText: DemographicStrings.departmentHint,
        rightIcon: TextFieldIcon.search,
        onChanged: (String input) {
          setState(() {
            if (input.isNotBlank()) {
              findDepartments = DepartmentHelper.getDepartment()
                  .where(
                    (department) => department.displayedName
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
    ];

    final totalLength = findDepartments.length;
    for (var index = 0; index < totalLength; index++) {
      final findDepartment = findDepartments[index];
      widgets.add(
        AgoraDemographicResponseCard(
          responseLabel: findDepartment.displayedName,
          isSelected: selectedDepartment == findDepartment,
          onTap: () {
            setState(() {
              if (selectedDepartment != findDepartment) {
                selectedDepartment = findDepartment;
              } else {
                selectedDepartment = null;
              }
            });
          },
          semantic: DemographicResponseCardSemantic(
            currentIndex: index + 1,
            totalIndex: totalLength,
          ),
        ),
      );
      widgets.add(SizedBox(height: AgoraSpacings.x0_25));
    }

    if (selectedDepartment != null && !findDepartments.contains(selectedDepartment)) {
      widgets.add(
        AgoraDemographicResponseCard(
          responseLabel: selectedDepartment!.displayedName,
          isSelected: true,
          onTap: () {
            setState(() {
              selectedDepartment = null;
            });
          },
          semantic: DemographicResponseCardSemantic(
            currentIndex: 1,
            totalIndex: totalLength,
          ),
        ),
      );
    }

    widgets.add(
      _EtrangerCheckbox(
        isCheck: selectedDepartment?.code == '99',
        onCheckChanged: (checked) {
          if (checked) {
            setState(() {
              selectedDepartment = DepartmentHelper.getHorsDeFranceDepartment();
            });
          } else {
            setState(() {
              selectedDepartment = null;
            });
          }
        },
      ),
    );

    widgets.addAll(
      [
        SizedBox(height: AgoraSpacings.x1_25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DemographicHelper.buildBackButton(step: widget.step, onBackTap: widget.onBackPressed),
            const SizedBox(width: AgoraSpacings.base),
            Flexible(
              child: selectedDepartment != null
                  ? DemographicHelper.buildNextButton(
                      step: widget.step,
                      totalStep: widget.totalStep,
                      onPressed: () => setState(() => widget.onContinuePressed(selectedDepartment!.code)),
                    )
                  : DemographicHelper.buildIgnoreButton(onPressed: widget.onIgnorePressed),
            ),
          ],
        ),
      ],
    );
    return widgets;
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
        vertical: AgoraSpacings.base,
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
