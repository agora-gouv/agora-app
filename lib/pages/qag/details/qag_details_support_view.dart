import 'package:agora/bloc/qag/details/qag_details_view_model.dart';
import 'package:agora/bloc/qag/support/qag_support_bloc.dart';
import 'package:agora/bloc/qag/support/qag_support_event.dart';
import 'package:agora/bloc/qag/support/qag_support_state.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_like_view.dart';
import 'package:agora/design/custom_view/button/agora_rounded_button.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagDetailsSupportView extends StatelessWidget {
  final String qagId;
  final bool canSupport;
  final QagDetailsSupportViewModel support;
  final Function(int supportCount, bool isSupported) onSupportChange;

  const QagDetailsSupportView({
    super.key,
    required this.qagId,
    required this.canSupport,
    required this.support,
    required this.onSupportChange,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QagSupportBloc, QagSupportState>(
      builder: (context, supportState) {
        final isSupported = support.isSupported;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (canSupport)
                  Flexible(
                    child: AgoraRoundedButton(
                      icon: _buildButtonIcon(isSupported, supportState),
                      label: _buildButtonLabel(isSupported, supportState),
                      style: _buildButtonStyle(isSupported, supportState),
                      isLoading: supportState is QagSupportLoadingState || supportState is QagDeleteSupportLoadingState,
                      contentAlignment: _buildButtonAlignment(isSupported, supportState),
                      onPressed: () => _buildOnPressed(context, qagId, isSupported, supportState),
                    ),
                  ),
                SizedBox(width: AgoraSpacings.x0_5),
                GestureDetector(
                  onTap: canSupport ? () => _buildOnPressed(context, qagId, isSupported, supportState) : null,
                  child: AgoraLikeView(
                    isSupported: _buildIsSupported(isSupported, supportState),
                    supportCount: _buildCount(support, supportState),
                    shouldHaveVerticalPadding: true,
                  ),
                ),
              ],
            ),
            if (supportState is QagSupportErrorState || supportState is QagDeleteSupportErrorState) ...[
              SizedBox(height: AgoraSpacings.base),
              AgoraErrorView(),
            ]
          ],
        );
      },
    );
  }

  int _buildCount(QagDetailsSupportViewModel serverSupportViewModel, QagSupportState supportState) {
    final isSupported = serverSupportViewModel.isSupported;
    final supportCount = serverSupportViewModel.count;
    if (!isSupported && supportState is QagSupportSuccessState) {
      final newSupportCount = supportCount + 1;
      onSupportChange(newSupportCount, true);
      return newSupportCount;
    } else if (isSupported && supportState is QagDeleteSupportSuccessState) {
      final newSupportCount = supportCount - 1;
      onSupportChange(newSupportCount, false);
      return newSupportCount;
    }
    onSupportChange(supportCount, isSupported);
    return supportCount;
  }

  String _buildButtonIcon(bool isSupported, QagSupportState supportState) {
    if (supportState is QagSupportInitialState) {
      if (isSupported) {
        return "ic_confirmation.svg";
      } else {
        return "ic_heart_white.svg";
      }
    } else {
      if (supportState is QagSupportSuccessState || supportState is QagDeleteSupportErrorState) {
        return "ic_confirmation.svg";
      } else if (supportState is QagSupportErrorState || supportState is QagDeleteSupportSuccessState) {
        return "ic_heart_white.svg";
      }
    }
    return ""; // value not important
  }

  CrossAxisAlignment _buildButtonAlignment(bool isSupported, QagSupportState supportState) {
    if (supportState is QagSupportInitialState) {
      if (isSupported) {
        return CrossAxisAlignment.center;
      } else {
        return CrossAxisAlignment.end;
      }
    } else {
      if (supportState is QagSupportSuccessState || supportState is QagDeleteSupportErrorState) {
        return CrossAxisAlignment.center;
      } else if (supportState is QagSupportErrorState || supportState is QagDeleteSupportSuccessState) {
        return CrossAxisAlignment.end;
      }
    }
    return CrossAxisAlignment.center; // value not important
  }

  bool _buildIsSupported(bool isSupported, QagSupportState supportState) {
    if (supportState is QagSupportInitialState || supportState is QagSupportLoadingState) {
      if (isSupported) {
        return true;
      } else {
        return false;
      }
    } else {
      if (supportState is QagSupportSuccessState || supportState is QagDeleteSupportErrorState) {
        return true;
      } else if (supportState is QagSupportErrorState || supportState is QagDeleteSupportSuccessState) {
        return false;
      }
    }
    return false; // value not important
  }

  String _buildButtonLabel(bool isSupported, QagSupportState supportState) {
    if (supportState is QagSupportInitialState) {
      if (isSupported) {
        return QagStrings.questionSupported;
      } else {
        return QagStrings.supportQuestion;
      }
    } else {
      if (supportState is QagSupportSuccessState || supportState is QagDeleteSupportErrorState) {
        return QagStrings.questionSupported;
      } else if (supportState is QagSupportErrorState || supportState is QagDeleteSupportSuccessState) {
        return QagStrings.supportQuestion;
      }
    }
    return ""; // value not important
  }

  AgoraRoundedButtonStyle _buildButtonStyle(bool isSupported, QagSupportState supportState) {
    if (supportState is QagSupportInitialState) {
      if (isSupported) {
        return AgoraRoundedButtonStyle.blueBorderButtonStyle;
      } else {
        return AgoraRoundedButtonStyle.primaryButtonStyle;
      }
    } else {
      if (supportState is QagSupportSuccessState || supportState is QagDeleteSupportErrorState) {
        return AgoraRoundedButtonStyle.blueBorderButtonStyle;
      } else if (supportState is QagSupportErrorState || supportState is QagDeleteSupportSuccessState) {
        return AgoraRoundedButtonStyle.primaryButtonStyle;
      }
    }
    return AgoraRoundedButtonStyle.blueBorderButtonStyle; // value not important
  }

  void _buildOnPressed(BuildContext context, String qagId, bool isSupported, QagSupportState supportState) {
    final qagSupportBloc = context.read<QagSupportBloc>();
    if (supportState is QagSupportInitialState) {
      if (isSupported) {
        _track(AnalyticsEventNames.unlikeQagDetails);
        qagSupportBloc.add(DeleteSupportQagEvent(qagId: qagId));
      } else {
        _track(AnalyticsEventNames.likeQagDetails);
        qagSupportBloc.add(SupportQagEvent(qagId: qagId));
      }
    } else {
      if (supportState is QagSupportSuccessState || supportState is QagDeleteSupportErrorState) {
        _track(AnalyticsEventNames.unlikeQagDetails);
        qagSupportBloc.add(DeleteSupportQagEvent(qagId: qagId));
      } else if (supportState is QagSupportErrorState || supportState is QagDeleteSupportSuccessState) {
        _track(AnalyticsEventNames.likeQagDetails);
        qagSupportBloc.add(SupportQagEvent(qagId: qagId));
      }
    }
  }

  void _track(String clickName) {
    TrackerHelper.trackClick(
      clickName: clickName,
      widgetName: AnalyticsScreenNames.qagDetailsPage,
    );
  }
}
