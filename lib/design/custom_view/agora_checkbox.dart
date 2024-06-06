import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class AgoraCheckbox extends StatelessWidget {
  final bool value;
  final String label;
  final void Function(bool) onChanged;

  const AgoraCheckbox({
    super.key,
    required this.value,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      toggled: value,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.all(AgoraCorners.rounded),
          onTap: () {
            onChanged(!value);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ExcludeSemantics(
                child: Checkbox(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  side: BorderSide(width: 2, color: AgoraColors.primaryBlue),
                  fillColor: WidgetStateProperty.all(value ? AgoraColors.primaryBlue : AgoraColors.transparent),
                  value: value,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      onChanged(newValue);
                    }
                  },
                ),
              ),
              SizedBox(width: AgoraSpacings.x0_5),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(bottom: AgoraSpacings.textAlignment),
                  child: Text(label, style: AgoraTextStyles.medium14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
