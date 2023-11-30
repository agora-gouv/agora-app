import 'package:agora/bloc/qag/details/qag_details_view_model.dart';
import 'package:agora/bloc/qag/support/qag_support_bloc.dart';
import 'package:agora/bloc/qag/support/qag_support_event.dart';
import 'package:agora/bloc/qag/support/qag_support_state.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_like_animation_view.dart';
import 'package:agora/design/custom_view/agora_like_view.dart';
import 'package:agora/design/custom_view/button/agora_rounded_button.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:equatable/equatable.dart';
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
    final likeAnimationView = AgoraLikeAnimationView(animationControllerKey: GlobalKey());

    return Stack(
      children: [
        BlocListener<QagSupportBloc, QagSupportState>(
          listenWhen: (previousState, currentState) {
            if (!_toLikeViewModel(previousState).isSupported && _toLikeViewModel(currentState).isSupported) {
              likeAnimationView.animate();
            }
            return false;
          },
          listener: (context, state) => {},
          child: likeAnimationView,
        ),
        BlocSelector<QagSupportBloc, QagSupportState, _ViewModel>(
          selector: (supportState) => _toViewModel(supportState),
          builder: (context, viewModel) {
            onSupportChange(viewModel.supportCount(), viewModel.isSupported());
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (canSupport)
                      Flexible(
                        child: AgoraRoundedButton(
                          icon: _buildButtonIcon(viewModel.isSupported()),
                          label: _buildButtonLabel(viewModel.isSupported()),
                          isLoading: viewModel.isLoading,
                          style: _buildButtonStyle(viewModel.isSupported()),
                          onPressed: () =>
                              _buildOnPressed(context, qagId, viewModel.isSupported(), viewModel.isLoading),
                        ),
                      ),
                    SizedBox(width: AgoraSpacings.x0_5),
                    Semantics(
                      button: canSupport,
                      child: GestureDetector(
                        onTap: canSupport
                            ? () => _buildOnPressed(context, qagId, viewModel.isSupported(), viewModel.isLoading)
                            : null,
                        child: AgoraLikeView(
                          isSupported: viewModel.isSupported(),
                          supportCount: viewModel.supportCount(),
                          shouldHaveVerticalPadding: true,
                          onDisplayRectAvailable: likeAnimationView.notifyDisplayRectAvailable,
                        ),
                      ),
                    ),
                  ],
                ),
                if (viewModel.hasError) ...[
                  SizedBox(height: AgoraSpacings.base),
                  AgoraErrorView(),
                ],
              ],
            );
          },
        ),
      ],
    );
  }

  _ViewModel _toViewModel(QagSupportState supportState) {
    return _ViewModel(
      isLoading: supportState is QagSupportLoadingState || supportState is QagDeleteSupportLoadingState,
      hasError: supportState is QagSupportErrorState || supportState is QagDeleteSupportErrorState,
      viewModel: _toLikeViewModel(supportState),
    );
  }

  AgoraLikeViewModel _toLikeViewModel(QagSupportState supportState) {
    return AgoraLikeViewModel(
      isSupported: _buildIsSupported(supportState),
      supportCount: _buildCount(supportState),
    );
  }

  bool _isInitiallySupported() {
    return support.isSupported;
  }

  int _initialSupportCount() {
    return support.count;
  }

  int _supportCountWhenUnliked() {
    return _initialSupportCount() - (_isInitiallySupported() ? 1 : 0);
  }

  bool _buildIsSupported(QagSupportState supportState) {
    if (supportState is QagSupportInitialState) {
      return _isInitiallySupported();
    } else if (supportState is QagSupportLoadingState) {
      return !_isInitiallySupported();
    } else {
      if (supportState is QagSupportSuccessState || supportState is QagDeleteSupportErrorState) {
        return true;
      } else if (supportState is QagSupportErrorState || supportState is QagDeleteSupportSuccessState) {
        return false;
      }
    }
    return false;
  }

  int _buildCount(QagSupportState supportState) {
    if (supportState is QagSupportInitialState) {
      return _initialSupportCount();
    } else if (supportState is QagSupportSuccessState || supportState is QagDeleteSupportErrorState) {
      return _supportCountWhenUnliked() + 1;
    } else if (supportState is QagDeleteSupportSuccessState || supportState is QagDeleteSupportSuccessState) {
      return _supportCountWhenUnliked();
    }
    return _initialSupportCount();
  }

  String _buildButtonIcon(bool isSupported) {
    if (isSupported) {
      return "ic_confirmation.svg";
    } else {
      return "ic_heart_white.svg";
    }
  }

  String _buildButtonLabel(bool isSupported) {
    if (isSupported) {
      return QagStrings.questionSupported;
    } else {
      return QagStrings.supportQuestion;
    }
  }

  AgoraRoundedButtonStyle _buildButtonStyle(bool isSupported) {
    if (isSupported) {
      return AgoraRoundedButtonStyle.blueBorderButtonStyle;
    } else {
      return AgoraRoundedButtonStyle.primaryButtonStyle;
    }
  }

  void _buildOnPressed(BuildContext context, String qagId, bool isSupported, bool isLoading) {
    if (!isLoading) {
      final qagSupportBloc = context.read<QagSupportBloc>();
      if (isSupported) {
        _track(AnalyticsEventNames.unlikeQagDetails);
        qagSupportBloc.add(DeleteSupportQagEvent(qagId: qagId));
      } else {
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

class _ViewModel extends Equatable {
  final bool isLoading;
  final bool hasError;
  final AgoraLikeViewModel viewModel;

  _ViewModel({required this.isLoading, required this.hasError, required this.viewModel});

  bool isSupported() {
    return viewModel.isSupported;
  }

  int supportCount() {
    return viewModel.supportCount;
  }

  @override
  List<Object?> get props => [viewModel];
}
