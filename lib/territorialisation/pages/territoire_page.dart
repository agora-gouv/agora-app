import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/strings/demographic_strings.dart';
import 'package:agora/design/custom_view/agora_demographic_simple_view.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/button/agora_secondary_style_view_button.dart';
import 'package:agora/design/custom_view/error/agora_error_text.dart';
import 'package:agora/design/custom_view/shake_widget.dart';
import 'package:agora/design/custom_view/text/agora_rich_text.dart';
import 'package:agora/design/custom_view/text/agora_text_field.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/profil/demographic/domain/department.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class TerritoirePage extends StatefulWidget {
  static const routeName = "/territoirePage";

  @override
  State<TerritoirePage> createState() => _TerritoirePageState();
}

class _TerritoirePageState extends State<TerritoirePage> {
  List<Department> findDepartements = [];
  List<Department> selectedDepartements = [];
  bool hasError = false;
  final _shakeKey = GlobalKey<ShakeWidgetState>();
  final firstElementKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AgoraScaffold(
      child: AgoraSecondaryStyleView(
        semanticPageLabel: "Mes territoires",
        title: AgoraRichText(
          key: firstElementKey,
          policeStyle: AgoraRichTextPoliceStyle.toolbar,
          items: [
            AgoraRichTextItem(
              text: "Mes territoires",
              style: AgoraRichTextItemStyle.bold,
            ),
          ],
        ),
        child: ShakeWidget(
          shakeCount: 4,
          key: _shakeKey,
          child: Padding(
            padding: const EdgeInsets.all(AgoraSpacings.base),
            child: Column(
              children: [
                Text(
                  "Choisissez les deux territoires qui vous intéressent :",
                  style: AgoraTextStyles.light16,
                ),
                SizedBox(height: AgoraSpacings.x2),
                if (hasError) ...[
                  AgoraErrorText(errorMessage: "Vous ne pouvez sélectionner que 2 territoire !"),
                  SizedBox(height: AgoraSpacings.x0_5),
                ],
                AgoraTextField(
                  hintText: DemographicStrings.departmentHint,
                  rightIcon: TextFieldIcon.search,
                  onChanged: (String input) {
                    setState(() {
                      if (input.isNotBlank()) {
                        findDepartements = DepartmentHelper.getDepartment()
                            .where(
                              (department) => department.displayedName
                                  .toLowerCase()
                                  .removeDiacritics()
                                  .removePunctuationMark()
                                  .contains(input.toLowerCase().removeDiacritics().removePunctuationMark()),
                            )
                            .toList();
                      } else {
                        findDepartements = [];
                      }
                    });
                  },
                ),
                SizedBox(height: AgoraSpacings.base),
                _Resultats(
                  findDepartements: findDepartements,
                  selectedDepartements: selectedDepartements,
                  onDepartementSelected: (departement) => setState(() {
                    if (selectedDepartements.contains(departement)) {
                      selectedDepartements.remove(departement);
                      hasError = false;
                    } else {
                      if (selectedDepartements.length == 2) {
                        _shakeKey.currentState?.shake();
                        Scrollable.ensureVisible(
                          firstElementKey.currentContext!,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                          alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart,
                        );
                        hasError = true;
                      } else {
                        hasError = false;
                        selectedDepartements.add(departement);
                      }
                    }
                  }),
                  onDepartementUnselected: (departement) => setState(() => selectedDepartements.remove(departement)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Resultats extends StatelessWidget {
  final List<Department> findDepartements;
  final List<Department> selectedDepartements;
  final Function(Department) onDepartementSelected;
  final Function(Department) onDepartementUnselected;

  const _Resultats({
    required this.findDepartements,
    required this.selectedDepartements,
    required this.onDepartementSelected,
    required this.onDepartementUnselected,
  });

  @override
  Widget build(BuildContext context) {
    final totalLength = findDepartements.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...findDepartements.mapIndexed(
          (index, departement) => AgoraDemographicResponseCard(
            responseLabel: departement.displayedName,
            isSelected: selectedDepartements.contains(departement),
            onTap: () => onDepartementSelected(departement),
            semantic: DemographicResponseCardSemantic(
              currentIndex: index + 1,
              totalIndex: totalLength,
            ),
          ),
        ),
        ...selectedDepartements.map(
          (selectedDepartements) {
            if (!findDepartements.contains((selectedDepartements))) {
              return AgoraDemographicResponseCard(
                responseLabel: selectedDepartements.displayedName,
                isSelected: true,
                onTap: () => onDepartementUnselected(selectedDepartements),
                semantic: DemographicResponseCardSemantic(
                  currentIndex: 1,
                  totalIndex: totalLength,
                ),
              );
            } else {
              return SizedBox();
            }
          },
        ),
      ],
    );
  }
}
