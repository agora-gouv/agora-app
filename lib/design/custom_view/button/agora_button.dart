import 'dart:math';

import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgoraButton extends StatefulWidget {
  static const MIN_TIME_BETWEEN_CLICKS = 1000;

  final String label;
  final void Function() onTap;
  final bool isLoading;
  final bool isExpanded;
  final bool isDisabled;
  final bool isRounded;
  final AgoraButtonStyle style;
  final double verticalPadding;
  final double horizontalPadding;
  final double loadingVerticalPadding;
  final double loadingHorizontalPadding;
  final String? semanticLabel;
  final String? prefixIcon;
  final EdgeInsets? prefixIconPadding;
  final ColorFilter? prefixIconColorFilter;
  final String? suffixIcon;
  final EdgeInsets? suffixIconPadding;
  final ColorFilter? suffixIconColorFilter;

  AgoraButton({
    required this.label,
    required this.onTap,
    this.isLoading = false,
    this.isExpanded = false,
    this.isDisabled = false,
    this.isRounded = false,
    this.style = AgoraButtonStyle.primary,
    this.verticalPadding = AgoraSpacings.x0_5,
    this.horizontalPadding = AgoraSpacings.x0_75,
    this.loadingVerticalPadding = AgoraSpacings.base,
    this.loadingHorizontalPadding = AgoraSpacings.x0_5,
    this.semanticLabel,
    this.prefixIcon,
    this.prefixIconPadding,
    this.prefixIconColorFilter,
    this.suffixIcon,
    this.suffixIconPadding,
    this.suffixIconColorFilter,
  });

  @override
  State<AgoraButton> createState() => _AgoraButtonState();
}

class _AgoraButtonState extends State<AgoraButton> with SingleTickerProviderStateMixin {
  var _shouldHandleClick = true;
  late AnimationController _controller;
  double _scale = 1;
  bool _isFocus = false;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.05,
    )..addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _tapDown(TapDownDetails details) => _controller.forward();

  void _tapUp(TapUpDetails details) => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    final radius = widget.isRounded ? AgoraCorners.rounded50 : AgoraCorners.rounded;
    final borderShape = RoundedRectangleBorder(borderRadius: BorderRadius.all(radius), side: _getBorder(widget.style));
    Widget child;
    child = Focus(
      canRequestFocus: false,
      onFocusChange: (focus) {
        setState(() {
          _isFocus = focus;
        });
      },
      child: Material(
        elevation: 0,
        color: AgoraColors.transparent,
        shape: borderShape,
        child: DecoratedBox(
          decoration: _isFocus
              ? BoxDecoration(
                  border: Border.all(
                    color: AgoraColors.focus,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(radius),
                )
              : const BoxDecoration(),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Transform.scale(
              scale: _scale,
              child: Semantics(
                label: widget.semanticLabel,
                button: true,
                enabled: !widget.isDisabled,
                child: widget.isLoading
                    ? AgoraLoadingButton(
                        color: _getBackgroundColor(widget.style, widget.isDisabled),
                        borderShape: borderShape,
                        loadingHorizontalPadding: widget.loadingHorizontalPadding,
                        loadingVerticalPadding: widget.loadingVerticalPadding,
                      )
                    : _Button(
                        label: widget.label,
                        controller: _controller,
                        onTapUp: widget.isDisabled ? null : _tapUp,
                        onTapDown: widget.isDisabled ? null : _tapDown,
                        isDisabled: widget.isDisabled,
                        style: widget.style,
                        handleClick: _handleClick,
                        horizontalPadding: widget.horizontalPadding,
                        verticalPadding: widget.verticalPadding,
                        color: _getBackgroundColor(widget.style, widget.isDisabled),
                        borderShape: borderShape,
                        prefixIcon: widget.prefixIcon,
                        prefixIconColorFilter: widget.prefixIconColorFilter,
                        prefixIconPadding: widget.prefixIconPadding,
                        suffixIcon: widget.suffixIcon,
                        suffixIconColorFilter: widget.suffixIconColorFilter,
                        suffixIconPadding: widget.suffixIconPadding,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
    if (widget.isExpanded) {
      child = SizedBox(width: double.infinity, child: child);
    }
    return child;
  }

  void _handleClick() {
    if (_shouldHandleClick && !widget.isLoading) {
      widget.onTap();
      _shouldHandleClick = false;
      Future.delayed(const Duration(milliseconds: AgoraButton.MIN_TIME_BETWEEN_CLICKS), () {
        _shouldHandleClick = true;
      });
    }
  }
}

class _Button extends StatelessWidget {
  final String label;
  final AnimationController controller;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final bool isDisabled;
  final void Function() handleClick;
  final double verticalPadding;
  final double horizontalPadding;
  final AgoraButtonStyle style;
  final Color color;
  final String? prefixIcon;
  final EdgeInsets? prefixIconPadding;
  final ColorFilter? prefixIconColorFilter;
  final String? suffixIcon;
  final EdgeInsets? suffixIconPadding;
  final ColorFilter? suffixIconColorFilter;
  final RoundedRectangleBorder borderShape;

  const _Button({
    required this.label,
    required this.controller,
    required this.onTapDown,
    required this.onTapUp,
    required this.isDisabled,
    required this.handleClick,
    required this.verticalPadding,
    required this.horizontalPadding,
    required this.style,
    required this.color,
    required this.prefixIcon,
    required this.prefixIconPadding,
    required this.prefixIconColorFilter,
    required this.suffixIcon,
    required this.suffixIconPadding,
    required this.suffixIconColorFilter,
    required this.borderShape,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 48,
        minWidth: 48,
      ),
      child: InkWell(
        onTapUp: onTapUp,
        onTapDown: onTapDown,
        onTapCancel: () => controller.reverse(),
        onTap: isDisabled ? null : () => handleClick(),
        customBorder: borderShape,
        child: Ink(
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: horizontalPadding,
          ),
          decoration: isDisabled
              ? ShapeDecoration(color: AgoraColors.disabled, shape: borderShape)
              : ShapeDecoration(
                  shape: borderShape,
                  color: color,
                ),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            alignment: WrapAlignment.center,
            children: [
              if (prefixIcon != null) ...[
                Padding(
                  padding: prefixIconPadding ?? EdgeInsets.zero,
                  child: SvgPicture.asset(
                    "assets/${prefixIcon!}",
                    excludeFromSemantics: true,
                    colorFilter: prefixIconColorFilter,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Text(label, textAlign: TextAlign.center, style: _getTextStyle(style)),
              if (suffixIcon != null) ...[
                const SizedBox(width: 8),
                Padding(
                  padding: suffixIconPadding ?? EdgeInsets.zero,
                  child: SvgPicture.asset(
                    "assets/${suffixIcon!}",
                    excludeFromSemantics: true,
                    colorFilter: suffixIconColorFilter,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class AgoraLoadingButton extends StatelessWidget {
  final Color color;
  final RoundedRectangleBorder borderShape;
  final double loadingVerticalPadding;
  final double loadingHorizontalPadding;

  const AgoraLoadingButton({
    required this.color,
    required this.borderShape,
    required this.loadingVerticalPadding,
    required this.loadingHorizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: double.infinity),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Ink(
            padding: EdgeInsets.symmetric(
              vertical: loadingVerticalPadding + 8,
              horizontal: min((constraints.maxWidth - 40) / 2, loadingHorizontalPadding),
            ),
            decoration: ShapeDecoration(color: color, shape: borderShape),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(color: AgoraColors.white, strokeWidth: 2),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Color _getBackgroundColor(AgoraButtonStyle style, bool isDisabled) {
  if (isDisabled) {
    return style == AgoraButtonStyle.primary ? AgoraColors.gravelFint : AgoraColors.stereotypicalDuck;
  } else {
    return switch (style) {
      AgoraButtonStyle.primary => AgoraColors.primaryBlue,
      AgoraButtonStyle.blueBorder || AgoraButtonStyle.redBorder => AgoraColors.transparent,
      AgoraButtonStyle.grey || AgoraButtonStyle.lightGreyWithBorder => AgoraColors.steam,
      AgoraButtonStyle.lightGrey => AgoraColors.cascadingWhite,
      AgoraButtonStyle.transparentWithBorder => AgoraColors.transparent,
    };
  }
}

TextStyle _getTextStyle(AgoraButtonStyle style) {
  return switch (style) {
    AgoraButtonStyle.primary => AgoraTextStyles.primaryButton,
    AgoraButtonStyle.blueBorder => AgoraTextStyles.primaryBlueTextButton,
    AgoraButtonStyle.redBorder => AgoraTextStyles.redTextButton,
    AgoraButtonStyle.grey ||
    AgoraButtonStyle.lightGrey ||
    AgoraButtonStyle.lightGreyWithBorder ||
    AgoraButtonStyle.transparentWithBorder =>
      AgoraTextStyles.lightGreyButton,
  };
}

BorderSide _getBorder(AgoraButtonStyle style) {
  return switch (style) {
    AgoraButtonStyle.primary || AgoraButtonStyle.grey || AgoraButtonStyle.lightGrey => BorderSide.none,
    AgoraButtonStyle.blueBorder => BorderSide(color: AgoraColors.primaryBlue, width: 1.0, style: BorderStyle.solid),
    AgoraButtonStyle.redBorder => BorderSide(color: AgoraColors.red, width: 1.0, style: BorderStyle.solid),
    AgoraButtonStyle.lightGreyWithBorder => BorderSide(color: AgoraColors.border, width: 1, style: BorderStyle.solid),
    AgoraButtonStyle.transparentWithBorder =>
      BorderSide(color: AgoraColors.orochimaru, width: 1, style: BorderStyle.solid),
  };
}

enum AgoraButtonStyle {
  primary,
  blueBorder,
  redBorder,
  grey,
  lightGrey,
  lightGreyWithBorder,
  transparentWithBorder,
}
