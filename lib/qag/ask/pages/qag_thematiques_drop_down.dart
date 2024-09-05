import 'package:agora/design/custom_view/card/agora_rounded_card.dart';
import 'package:agora/design/custom_view/card/agora_thematique_card.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/thematique/bloc/thematique_with_id_view_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class QagThematiquesDropDown<T> extends StatefulWidget {
  final T? firstValue;
  final List<T> elements;
  final String hintText;
  final Function(T) onSelected;

  const QagThematiquesDropDown({
    super.key,
    required this.firstValue,
    required this.elements,
    required this.hintText,
    required this.onSelected,
  });

  @override
  State<QagThematiquesDropDown<T>> createState() => _QagThematiquesDropDownState<T>();
}

class _QagThematiquesDropDownState<T> extends State<QagThematiquesDropDown<T>> {
  T? dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.firstValue;
  }

  @override
  Widget build(BuildContext context) {
    return AgoraRoundedCard(
      borderColor: AgoraColors.borderHintColor,
      padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.base),
      child: DropdownButton<T>(
        value: dropdownValue,
        icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        isExpanded: true,
        borderRadius: BorderRadius.all(AgoraCorners.rounded),
        underline: Container(),
        hint: Text(widget.hintText, style: AgoraTextStyles.light14.copyWith(color: AgoraColors.hintColor)),
        onChanged: (T? value) {
          setState(() {
            dropdownValue = value as T;
            widget.onSelected(value);
          });
        },
        itemHeight: null,
        items: widget.elements.mapIndexed<DropdownMenuItem<T>>((index, T value) {
          final thematique = value as ThematiqueWithIdViewModel;
          return DropdownMenuItem<T>(
            value: value,
            child: AgoraThematiqueLabel(
              picto: thematique.picto,
              label: thematique.label,
              size: AgoraThematiqueSize.medium,
            ),
          );
        }).toList(),
      ),
    );
  }
}
