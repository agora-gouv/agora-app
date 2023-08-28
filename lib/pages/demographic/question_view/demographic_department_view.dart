import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/strings/demographic_strings.dart';
import 'package:agora/design/custom_view/agora_demographic_simple_view.dart';
import 'package:agora/design/custom_view/agora_text_field.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/style/agora_button_style.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/domain/demographic/department.dart';
import 'package:agora/pages/demographic/demographic_helper.dart';
import 'package:flutter/material.dart';

class DemographicDepartmentView extends StatefulWidget {
  final Function(String responseCode) onContinuePressed;
  final VoidCallback onIgnorePressed;

  const DemographicDepartmentView({
    super.key,
    required this.onContinuePressed,
    required this.onIgnorePressed,
  });

  @override
  State<DemographicDepartmentView> createState() => _DemographicDepartmentViewState();
}

class _DemographicDepartmentViewState extends State<DemographicDepartmentView> {
  List<Department> findDepartments = [];
  Department? selectedDepartment;

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
              if (!findDepartments.contains(selectedDepartment)) {
                selectedDepartment = null;
              }
            } else {
              findDepartments = [];
              selectedDepartment = null;
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

    widgets.addAll(
      [
        SizedBox(height: AgoraSpacings.x1_25),
        selectedDepartment != null
            ? AgoraButton(
                label: DemographicStrings.continu,
                style: AgoraButtonStyle.primaryButtonStyle,
                onPressed: () => setState(() => widget.onContinuePressed(selectedDepartment!.code)),
              )
            : DemographicHelper.buildIgnoreButton(onPressed: () => setState(() => widget.onIgnorePressed())),
      ],
    );
    return widgets;
  }
}
