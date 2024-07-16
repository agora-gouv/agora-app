import 'package:agora/qag/repository/presenter/qag_display_model.dart';
import 'package:agora/qag/details/bloc/support/qag_support_bloc.dart';
import 'package:agora/qag/details/bloc/support/qag_support_event.dart';
import 'package:agora/qag/details/bloc/support/qag_support_state.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/design/custom_view/agora_like_animation_view.dart';
import 'package:agora/design/custom_view/agora_like_view.dart';
import 'package:agora/design/custom_view/card/agora_question_card.dart';
import 'package:agora/qag/domain/qag_support.dart';
import 'package:agora/qag/details/pages/qag_details_page.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagsSupportableCard extends StatelessWidget {
  final QagDisplayModel qagViewModel;
  final String widgetName;
  final Function(QagSupport)? onQagSupportChange;

  const QagsSupportableCard({
    super.key,
    required this.qagViewModel,
    required this.widgetName,
    this.onQagSupportChange,
  });

  @override
  Widget build(BuildContext context) {
    final likeViewKey = GlobalKey();
    final likeAnimationView = AgoraLikeAnimationView(animationControllerKey: GlobalKey(), likeViewKey: likeViewKey);

    return Stack(
      children: [
        BlocSelector<QagSupportBloc, QagSupportState, _ViewModel>(
          selector: (supportState) => _toViewModel(supportState),
          builder: (context, viewModel) {
            return AgoraQuestionCard(
              id: qagViewModel.id,
              thematique: qagViewModel.thematique,
              titre: qagViewModel.title,
              nom: qagViewModel.username,
              date: qagViewModel.date,
              supportCount: viewModel.supportCount(),
              isSupported: viewModel.isSupported(),
              isAuthor: qagViewModel.isAuthor,
              onSupportClick: (bool support) {
                if (support) {
                  TrackerHelper.trackClick(
                    clickName: AnalyticsEventNames.likeQag,
                    widgetName: widgetName,
                  );
                  context.read<QagSupportBloc>().add(SupportQagEvent(qagId: qagViewModel.id));
                } else {
                  TrackerHelper.trackClick(
                    clickName: AnalyticsEventNames.unlikeQag,
                    widgetName: widgetName,
                  );
                  context.read<QagSupportBloc>().add(DeleteSupportQagEvent(qagId: qagViewModel.id));
                }
              },
              onCardClick: () {
                Navigator.pushNamed(
                  context,
                  QagDetailsPage.routeName,
                  arguments: QagDetailsArguments(qagId: qagViewModel.id, reload: QagReload.qagsPage), // FIXME
                ).then((result) {
                  if (onQagSupportChange != null && result != null && result is QagDetailsBackResult) {
                    onQagSupportChange!(
                      QagSupport(
                        qagId: result.qagId,
                        isSupported: result.isSupported,
                        supportCount: result.supportCount,
                      ),
                    );
                  }
                });
              },
              likeViewKey: likeViewKey,
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
    );
  }

  _ViewModel _toViewModel(QagSupportState supportState) {
    return _ViewModel(
      isLoading: supportState is QagSupportLoadingState || supportState is QagDeleteSupportLoadingState,
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
    return qagViewModel.isSupported;
  }

  int _initialSupportCount() {
    return qagViewModel.supportCount;
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
}

class _ViewModel extends Equatable {
  final bool isLoading;
  final AgoraLikeViewModel viewModel;

  _ViewModel({required this.isLoading, required this.viewModel});

  bool isSupported() {
    return viewModel.isSupported;
  }

  int supportCount() {
    return viewModel.supportCount;
  }

  @override
  List<Object?> get props => [viewModel];
}
