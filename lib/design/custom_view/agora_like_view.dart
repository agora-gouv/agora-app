import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AgoraLikeStyle {
  police12,
  police14,
  police16,
}

class AgoraLikeView extends StatelessWidget {
  final bool isSupported;
  final int supportCount;
  final bool shouldHaveHorizontalPadding;
  final bool shouldHaveVerticalPadding;
  final AgoraLikeStyle style;
  final Function(bool support)? onSupportClick;
  final GlobalKey? likeViewKey;
  final bool shouldVocaliseSupport;
  final bool isQuestionGagnante;
  final bool withContour;

  const AgoraLikeView({
    super.key,
    required this.isSupported,
    required this.supportCount,
    this.shouldHaveHorizontalPadding = true,
    this.shouldHaveVerticalPadding = false,
    this.style = AgoraLikeStyle.police14,
    this.onSupportClick,
    this.likeViewKey,
    this.shouldVocaliseSupport = true,
    this.isQuestionGagnante = false,
    this.withContour = true,
  });

  @override
  Widget build(BuildContext context) {
    if (isQuestionGagnante) {
      return _AgoraLikeViewNonCliquable(
        supportCount,
        shouldHaveHorizontalPadding,
        shouldHaveVerticalPadding,
        style,
        likeViewKey,
        shouldVocaliseSupport,
      );
    } else {
      return _AgoraLikeViewCliquable(
        isSupported,
        supportCount,
        shouldHaveHorizontalPadding,
        shouldHaveVerticalPadding,
        style,
        onSupportClick,
        likeViewKey,
        shouldVocaliseSupport,
        withContour,
      );
    }
  }
}

class _AgoraLikeViewCliquable extends StatelessWidget {
  final bool isSupported;
  final int supportCount;
  final bool shouldHaveHorizontalPadding;
  final bool shouldHaveVerticalPadding;
  final AgoraLikeStyle style;
  final Function(bool support)? onSupportClick;
  final GlobalKey? likeViewKey;
  final bool shouldVocaliseSupport;
  final bool withContour;

  const _AgoraLikeViewCliquable(
    this.isSupported,
    this.supportCount,
    this.shouldHaveHorizontalPadding,
    this.shouldHaveVerticalPadding,
    this.style,
    this.onSupportClick,
    this.likeViewKey,
    this.shouldVocaliseSupport,
    this.withContour,
  );

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onSupportClick != null,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 44, minWidth: 44),
        child: InkWell(
          borderRadius: BorderRadius.all(withContour ? AgoraCorners.rounded42 : AgoraCorners.rounded),
          onTap: onSupportClick != null ? () => onSupportClick!(!isSupported) : null,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(AgoraCorners.rounded42),
              border: Border.all(color: withContour ? AgoraColors.lightRedOpacity19 : AgoraColors.transparent),
              color: withContour ? AgoraColors.lightRedOpacity4 : AgoraColors.transparent,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: shouldHaveHorizontalPadding ? AgoraSpacings.x0_75 : AgoraSpacings.x0_375,
                vertical: shouldHaveVerticalPadding ? 2 : 0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    key: likeViewKey,
                    _getIcon(isSupported),
                    width: _buildIconSize(style),
                    excludeFromSemantics: true,
                  ),
                  SizedBox(width: AgoraSpacings.x0_25),
                  Padding(
                    padding: const EdgeInsets.only(bottom: AgoraSpacings.x0_25),
                    child: Text(
                      supportCount.toString(),
                      style: _buildTextStyle(style, withContour),
                      semanticsLabel:
                          "${shouldVocaliseSupport ? isSupported ? SemanticsStrings.support : SemanticsStrings.notSupport : ''}\n${SemanticsStrings.supportNumber.format(supportCount.toString())}",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AgoraLikeViewNonCliquable extends StatelessWidget {
  final int supportCount;
  final bool shouldHaveHorizontalPadding;
  final bool shouldHaveVerticalPadding;
  final AgoraLikeStyle style;
  final GlobalKey? likeViewKey;
  final bool shouldVocaliseSupport;

  const _AgoraLikeViewNonCliquable(
    this.supportCount,
    this.shouldHaveHorizontalPadding,
    this.shouldHaveVerticalPadding,
    this.style,
    this.likeViewKey,
    this.shouldVocaliseSupport,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: shouldHaveHorizontalPadding ? AgoraSpacings.x0_75 : AgoraSpacings.x0_375,
        vertical: shouldHaveVerticalPadding ? 2 : 0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            key: likeViewKey,
            _getIcon(true),
            width: _buildIconSize(style),
            excludeFromSemantics: true,
          ),
          SizedBox(width: AgoraSpacings.x0_25),
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              supportCount.toString(),
              style: _buildTextStyle(style),
              semanticsLabel:
                  "${shouldVocaliseSupport ? SemanticsStrings.support : SemanticsStrings.notSupport}\n${SemanticsStrings.supportNumber.format(supportCount.toString())}",
            ),
          ),
        ],
      ),
    );
  }
}

class AgoraLike extends StatelessWidget {
  final bool isSupported;
  final int supportCount;
  final bool shouldHaveHorizontalPadding;
  final bool shouldHaveVerticalPadding;
  final AgoraLikeStyle style;
  final GlobalKey? likeViewKey;
  final bool shouldVocaliseSupport;
  final bool isLoading;

  const AgoraLike({
    required this.isSupported,
    required this.supportCount,
    this.shouldHaveHorizontalPadding = true,
    this.shouldHaveVerticalPadding = false,
    this.style = AgoraLikeStyle.police14,
    this.likeViewKey,
    this.shouldVocaliseSupport = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(AgoraCorners.rounded42),
        border: Border.all(color: AgoraColors.lightRedOpacity19),
        color: AgoraColors.lightRedOpacity4,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: shouldHaveHorizontalPadding ? AgoraSpacings.x0_75 : AgoraSpacings.x0_375,
          vertical: shouldHaveVerticalPadding ? 2 : 0,
        ),
        child: isLoading
            ? _LikeLoading()
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    key: likeViewKey,
                    _getIcon(isSupported),
                    width: _buildIconSize(style),
                    excludeFromSemantics: true,
                  ),
                  SizedBox(width: AgoraSpacings.x0_25),
                  Padding(
                    padding: const EdgeInsets.only(bottom: AgoraSpacings.x0_25),
                    child: Text(
                      supportCount.toString(),
                      style: _buildTextStyle(style),
                      semanticsLabel:
                          "${shouldVocaliseSupport ? isSupported ? SemanticsStrings.support : SemanticsStrings.notSupport : ''}\n${SemanticsStrings.supportNumber.format(supportCount.toString())}",
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _LikeLoading extends StatelessWidget {
  const _LikeLoading();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(color: AgoraColors.red, strokeWidth: 2),
      ),
    );
  }
}

double _buildIconSize(AgoraLikeStyle style) {
  return switch (style) {
    AgoraLikeStyle.police12 => 14,
    AgoraLikeStyle.police14 => 18,
    AgoraLikeStyle.police16 => 22,
  };
}

TextStyle _buildTextStyle(AgoraLikeStyle style, [bool withContour = true]) {
  return switch (style) {
    AgoraLikeStyle.police12 =>
      withContour ? AgoraTextStyles.medium12 : AgoraTextStyles.medium12.copyWith(color: AgoraColors.red),
    AgoraLikeStyle.police14 =>
      withContour ? AgoraTextStyles.medium14 : AgoraTextStyles.medium14.copyWith(color: AgoraColors.red),
    AgoraLikeStyle.police16 =>
      withContour ? AgoraTextStyles.medium16 : AgoraTextStyles.medium16.copyWith(color: AgoraColors.red),
  };
}

String _getIcon(bool isSupported) {
  if (isSupported) {
    return "assets/ic_heart_full.svg";
  } else {
    return "assets/ic_heart.svg";
  }
}

class AgoraLikeViewModel extends Equatable {
  final bool isSupported;
  final int supportCount;

  AgoraLikeViewModel({required this.isSupported, required this.supportCount});

  @override
  List<Object?> get props => [isSupported, supportCount];
}
