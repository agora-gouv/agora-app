import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class AgoraCheckbox extends StatefulWidget {
  final bool defaultValue;
  final String label;
  final Function(bool) onChanged;

  const AgoraCheckbox({
    Key? key,
    required this.defaultValue,
    required this.label,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<AgoraCheckbox> createState() => _AgoraCheckboxState();
}

class _AgoraCheckboxState extends State<AgoraCheckbox> {
  late bool value;

  @override
  void initState() {
    super.initState();
    value = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.all(AgoraCorners.rounded),
      onTap: () => setState(() {
        value = !value;
        widget.onChanged(value);
      }),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            fillColor: MaterialStateProperty.all(AgoraColors.primaryBlue),
            value: value,
            onChanged: (newValue) => setState(
              () {
                if (newValue != null) {
                  value = newValue;
                }
                widget.onChanged(value);
              },
            ),
          ),
          SizedBox(width: AgoraSpacings.x0_5),
          Expanded(child: Text(widget.label, style: AgoraTextStyles.medium14)),
        ],
      ),
    );
  }
}
