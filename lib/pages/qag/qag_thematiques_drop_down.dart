import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:agora/design/agora_corners.dart';
import 'package:agora/design/custom_view/agora_thematique_card.dart';
import 'package:flutter/material.dart';

class QagThematiquesDropDown<T> extends StatefulWidget {
  final List<T> elements;
  final Function(T) onSelected;

  const QagThematiquesDropDown({super.key, required this.elements, required this.onSelected});

  @override
  State<QagThematiquesDropDown<T>> createState() => _QagThematiquesDropDownState<T>();
}

class _QagThematiquesDropDownState<T> extends State<QagThematiquesDropDown<T>> {
  T? dropdownValue;

  @override
  Widget build(BuildContext context) {
    dropdownValue ??= widget.elements.first;
    return DropdownButton<T>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      isExpanded: true,
      borderRadius: BorderRadius.all(AgoraCorners.rounded),
      underline: Container(),
      onChanged: (T? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value as T;
          widget.onSelected(value);
        });
      },
      items: widget.elements.map<DropdownMenuItem<T>>((T value) {
        final thematique = value as ThematiqueViewModel;
        return DropdownMenuItem<T>(
          value: value,
          child: AgoraThematiqueCard(
            picto: thematique.picto,
            label: thematique.label,
            color: thematique.color,
          ),
        );
      }).toList(),
    );
  }
}
