import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AgoraFiltreItem extends Equatable {
  final String label;
  final bool isSelected;
  final void Function() onSelect;

  const AgoraFiltreItem({required this.label, required this.isSelected, required this.onSelect});

  @override
  List<Object?> get props => [label, isSelected];
}

class AgoraFiltre extends StatefulWidget {
  final List<AgoraFiltreItem> items;

  const AgoraFiltre(this.items);

  @override
  State<AgoraFiltre> createState() => _AgoraFiltreState();
}

class _AgoraFiltreState extends State<AgoraFiltre> {
  Map<String, bool> areSelected = {};

  @override
  void initState() {
    areSelected = Map.of({for (var item in widget.items) item.label: item.isSelected});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ...widget.items.map(
          (item) => AgoraFiltreTag(
            label: item.label,
            isSelected: areSelected[item.label]!,
            onSelect: () {
              if (!areSelected[item.label]!) {
                setState(() {
                  areSelected = Map.of({for (var item in widget.items) item.label: false});
                  areSelected[item.label] = true;
                });
                item.onSelect();
              }
            },
          ),
        ),
      ],
    );
  }
}

class AgoraFiltreTag extends StatelessWidget {
  final String label;
  final bool isSelected;
  final void Function() onSelect;

  const AgoraFiltreTag({required this.label, required this.isSelected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 44, minHeight: 44),
            child: Ink(
              decoration: BoxDecoration(
                color: isSelected ? AgoraColors.primaryBlue : AgoraColors.unselectedFiltre,
                borderRadius: BorderRadius.circular(20),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: onSelect,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Text(
                    label,
                    style: AgoraTextStyles.light14
                        .copyWith(color: isSelected ? AgoraColors.white : AgoraColors.primaryBlue),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (isSelected)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: AgoraColors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline,
                color: AgoraColors.primaryBlue,
                size: 20,
              ),
            ),
          ),
      ],
    );
  }
}
