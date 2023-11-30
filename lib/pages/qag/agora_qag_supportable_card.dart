import 'package:agora/bloc/qag/qag_view_model.dart';
import 'package:agora/bloc/qag/support/qag_support_bloc.dart';
import 'package:agora/bloc/qag/support/qag_support_event.dart';
import 'package:agora/bloc/qag/support/qag_support_state.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/design/custom_view/agora_like_animation_view.dart';
import 'package:agora/design/custom_view/agora_like_view.dart';
import 'package:agora/design/custom_view/agora_qag_card.dart';
<<<<<<< HEAD
import 'package:agora/domain/qag/qag_support.dart';
=======
>>>>>>> 84cc3d4 (Add animation on QagSearch)
import 'package:agora/pages/qag/details/qag_details_page.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AgoraQagSupportableCard extends StatelessWidget {
  final QagViewModel qagViewModel;
  final String widgetName;
<<<<<<< HEAD
  final Function(QagSupport)? onQagSupportChange;
=======
>>>>>>> 84cc3d4 (Add animation on QagSearch)

  const AgoraQagSupportableCard({
    super.key,
    required this.qagViewModel,
    required this.widgetName,
<<<<<<< HEAD
    this.onQagSupportChange,
=======
>>>>>>> 84cc3d4 (Add animation on QagSearch)
  });

  @override
  Widget build(BuildContext context) {
    final likeAnimationView = AgoraLikeAnimationView(animationControllerKey: GlobalKey());

    return Stack(
      children: [
        BlocSelector<QagSupportBloc, QagSupportState, _ViewModel>(
          selector: (supportState) => _toViewModel(supportState),
          builder: (context, viewModel) {
            return AgoraQagCard(
              id: qagViewModel.id,
              thematique: qagViewModel.thematique,
              title: qagViewModel.title,
              username: qagViewModel.username,
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
<<<<<<< HEAD
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
=======
                );
>>>>>>> 84cc3d4 (Add animation on QagSearch)
              },
              onDisplayRectAvailable: likeAnimationView.notifyDisplayRectAvailable,
            );
          },
        ),
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
