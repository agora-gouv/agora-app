import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/design/custom_view/agora_like_animation_view.dart';
import 'package:agora/design/custom_view/agora_like_view.dart';
import 'package:agora/qag/details/bloc/qag_details_view_model.dart';
import 'package:agora/qag/details/bloc/support/qag_support_bloc.dart';
import 'package:agora/qag/details/bloc/support/qag_support_event.dart';
import 'package:agora/qag/details/bloc/support/qag_support_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final likeViewKey = GlobalKey();

class QagDetailsSupportView extends StatelessWidget {
  final String qagId;
  final bool canSupport;
  final bool isQuestionGagnante;
  final QagDetailsSupportViewModel supportViewModel;
  final QagSupportBloc? qagSupportBloc;
  final Function(int supportCount, bool isSupported) onSupportChange;

  const QagDetailsSupportView({
    super.key,
    required this.qagId,
    required this.canSupport,
    this.isQuestionGagnante = false,
    required this.supportViewModel,
    this.qagSupportBloc,
    required this.onSupportChange,
  });

  @override
  Widget build(BuildContext context) {
    final likeAnimationView = AgoraLikeAnimationView(animationControllerKey: GlobalKey(), likeViewKey: likeViewKey);

    return BlocProvider.value(
      value: qagSupportBloc ?? QagSupportBloc(qagRepository: RepositoryManager.getQagRepository()),
      child: Stack(
        children: [
          BlocSelector<QagSupportBloc, QagSupportState, _ViewModel>(
            selector: (supportState) => _toViewModel(supportState),
            builder: (context, viewModel) {
              onSupportChange(viewModel.supportCount, viewModel.isSupported);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    button: canSupport,
                    child: InkWell(
                      onTap: canSupport ? () => _buildOnPressed(context, qagId, viewModel) : null,
                      child: AgoraLikeView(
                        isSupported: viewModel.isSupported,
                        supportCount: viewModel.supportCount,
                        shouldHaveVerticalPadding: true,
                        likeViewKey: likeViewKey,
                        shouldVocaliseSupport: canSupport,
                        isQuestionGagnante: isQuestionGagnante,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          BlocListener<QagSupportBloc, QagSupportState>(
            listenWhen: (previousState, currentState) {
              if (!_toLikeViewModel(previousState).isSupported && _toLikeViewModel(currentState).isSupported) {
                likeAnimationView.animate();
              }
              if (_toLikeViewModel(previousState).isSupported && !_toLikeViewModel(currentState).isSupported) {
                likeAnimationView.reverseAnimate();
              }
              return false;
            },
            listener: (context, state) => {},
            child: likeAnimationView,
          ),
        ],
      ),
    );
  }

  _ViewModel _toViewModel(QagSupportState supportState) {
    return _ViewModel(
      isLoading: supportState is QagSupportLoadingState,
      isSupported: _buildIsSupported(supportState),
      supportCount: _buildCount(supportState),
    );
  }

  AgoraLikeViewModel _toLikeViewModel(QagSupportState supportState) {
    return AgoraLikeViewModel(
      isSupported: _buildIsSupported(supportState),
      supportCount: _buildCount(supportState),
    );
  }

  bool _isInitiallySupported() {
    return supportViewModel.isSupported;
  }

  int _initialSupportCount() {
    return supportViewModel.count;
  }

  bool _buildIsSupported(QagSupportState supportState) {
    if (supportState is QagSupportInitialState) {
      return _isInitiallySupported();
    } else if (supportState is QagSupportLoadingState) {
      return !_isInitiallySupported();
    } else {
      if (supportState is QagSupportSuccessState) {
        return supportState.isSupported;
      } else if (supportState is QagSupportErrorState) {
        return false;
      }
    }
    return false;
  }

  int _buildCount(QagSupportState supportState) {
    if (supportState is QagSupportInitialState) {
      return _initialSupportCount();
    } else if (supportState is QagSupportSuccessState) {
      return supportState.supportCount;
    }
    return _initialSupportCount();
  }

  void _buildOnPressed(BuildContext context, String qagId, _ViewModel viewModel) {
    if (!viewModel.isLoading) {
      final qagSupportBloc = context.read<QagSupportBloc>();
      if (viewModel.isSupported) {
        _track(AnalyticsEventNames.unlikeQagDetails);
        qagSupportBloc.add(
          DeleteSupportQagEvent(
            qagId: qagId,
            supportCount: viewModel.supportCount,
            isSupported: viewModel.isSupported,
          ),
        );
      } else {
        _track(AnalyticsEventNames.likeQagDetails);
        qagSupportBloc.add(
          SupportQagEvent(
            qagId: qagId,
            supportCount: viewModel.supportCount,
            isSupported: viewModel.isSupported,
          ),
        );
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
  final bool isSupported;
  final int supportCount;

  _ViewModel({required this.isLoading, required this.isSupported, required this.supportCount});

  @override
  List<Object?> get props => [isLoading, isSupported, supportCount];
}
