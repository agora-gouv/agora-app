import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/extension/qag_list_filter_extension.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_qag_header.dart';
import 'package:agora/design/custom_view/button/agora_button.dart';
import 'package:agora/design/custom_view/error/agora_error_view.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/qag/ask/pages/qag_ask_question_page.dart';
import 'package:agora/qag/details/bloc/support/qag_support_bloc.dart';
import 'package:agora/qag/domain/qas_list_filter.dart';
import 'package:agora/qag/list/bloc/qag_list_bloc.dart';
import 'package:agora/qag/list/bloc/qag_list_event.dart';
import 'package:agora/qag/list/bloc/qag_list_state.dart';
import 'package:agora/qag/list/pages/qags_list_loading.dart';
import 'package:agora/qag/repository/presenter/qag_display_model.dart';
import 'package:agora/qag/repository/presenter/qag_presenter.dart';
import 'package:agora/qag/widgets/qags_supportable_card.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QagListSection extends StatelessWidget {
  final String? thematiqueId;
  final String? thematiqueLabel;
  final QagListFilter qagFilter;

  const QagListSection({
    required this.qagFilter,
    required this.thematiqueId,
    this.thematiqueLabel,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.70,
      ),
      child: BlocSelector<QagListBloc, QagListState, _ViewModel>(
        selector: _ViewModel.fromState,
        builder: (context, viewModel) {
          if (viewModel is _QagListLoadingViewModel) {
            return QagsListLoading();
          } else if (viewModel is _QagListWithResultViewModel) {
            return _QagListView(viewModel: viewModel, qagFilter: qagFilter, thematiqueId: thematiqueId);
          } else if (viewModel is _QagListNoResultViewModel) {
            return _NoResult(viewModel);
          } else {
            return _Error(thematiqueId: thematiqueId, thematiqueLabel: thematiqueLabel, qagFilter: qagFilter);
          }
        },
      ),
    );
  }
}

class _QagListView extends StatefulWidget {
  final _QagListWithResultViewModel viewModel;
  final QagListFilter qagFilter;
  final String? thematiqueId;

  const _QagListView({
    required this.viewModel,
    required this.qagFilter,
    required this.thematiqueId,
  });

  @override
  State<_QagListView> createState() => _QagListViewState();
}

class _QagListViewState extends State<_QagListView> {
  List<GlobalKey> likeViewKeys = [];

  @override
  void initState() {
    likeViewKeys = List.generate(widget.viewModel.qags.length, (index) => GlobalKey());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _HeaderQag(widget.viewModel.header),
        Semantics(
          label:
              'Liste des questions au gouvernement dans la catégorie ${widget.qagFilter.toFilterLabel()}, nombre d\'éléments ${widget.viewModel.qags.length}',
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: AgoraSpacings.base);
            },
            itemCount: widget.viewModel.hasFooter ? widget.viewModel.qags.length + 1 : widget.viewModel.qags.length,
            itemBuilder: (context, index) {
              if (index < widget.viewModel.qags.length) {
                final item = widget.viewModel.qags[index];
                return BlocProvider.value(
                  value: QagSupportBloc(qagRepository: RepositoryManager.getQagRepository()),
                  child: QagsSupportableCard(
                    key: Key(item.id),
                    qagViewModel: item,
                    widgetName: AnalyticsScreenNames.qagsPage,
                    onQagSupportChange: (qagSupport) {
                      context.read<QagListBloc>().add(UpdateQagListSupportEvent(qagSupport: qagSupport));
                    },
                    likeViewKey: likeViewKeys[index],
                  ),
                );
              } else if (widget.viewModel.hasFooter) {
                switch (widget.viewModel.footerType) {
                  case QagListFooterType.loading:
                    return Center(child: CircularProgressIndicator());
                  case QagListFooterType.loaded:
                    return Center(
                      child: AgoraButton(
                        label: GenericStrings.displayMore,
                        buttonStyle: AgoraButtonStyle.tertiary,
                        onPressed: () {
                          context.read<QagListBloc>().add(
                                UpdateQagsListEvent(
                                  thematiqueId: widget.thematiqueId,
                                  qagFilter: widget.qagFilter,
                                ),
                              );
                        },
                      ),
                    );
                  case QagListFooterType.error:
                    return AgoraErrorView(
                      onReload: () => context.read<QagListBloc>().add(
                            UpdateQagsListEvent(
                              thematiqueId: widget.thematiqueId,
                              qagFilter: widget.qagFilter,
                            ),
                          ),
                    );
                }
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({
    required this.thematiqueId,
    required this.thematiqueLabel,
    required this.qagFilter,
  });

  final String? thematiqueId;
  final String? thematiqueLabel;
  final QagListFilter qagFilter;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: AgoraSpacings.base),
        AgoraErrorView(
          onReload: () => context.read<QagListBloc>().add(
                FetchQagsListEvent(
                  thematiqueId: thematiqueId,
                  thematiqueLabel: thematiqueLabel,
                  qagFilter: qagFilter,
                ),
              ),
        ),
      ],
    );
  }
}

class _NoResult extends StatelessWidget {
  final _QagListNoResultViewModel viewModel;

  const _NoResult(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HeaderQag(viewModel.header),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                QagStrings.emptyList,
                style: AgoraTextStyles.medium14,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AgoraSpacings.x1_5),
              AgoraButton(
                label: QagStrings.askQuestion,
                onPressed: () {
                  TrackerHelper.trackClick(
                    clickName: AnalyticsEventNames.askQuestionInEmptyList,
                    widgetName: AnalyticsScreenNames.qagsPage,
                  );
                  Navigator.pushNamed(context, QagAskQuestionPage.routeName);
                },
              ),
            ],
          ),
        ),
        SizedBox(height: AgoraSpacings.x3 * 2),
      ],
    );
  }
}

class _HeaderQag extends StatelessWidget {
  final _QagListHeaderViewModel? viewModel;

  const _HeaderQag(this.viewModel);

  @override
  Widget build(BuildContext context) {
    if (viewModel != null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(
          AgoraSpacings.horizontalPadding,
          0,
          AgoraSpacings.horizontalPadding,
          AgoraSpacings.base,
        ),
        child: Center(
          child: AgoraQagHeader(
            id: viewModel!.id,
            title: viewModel!.title,
            message: viewModel!.message,
            onCloseHeader: (headerId) {
              context.read<QagListBloc>().add(CloseHeaderQagListEvent(headerId: headerId));
            },
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }
}

abstract class _ViewModel extends Equatable {
  static _ViewModel fromState(QagListState state) {
    if (state is QagListLoadingState) {
      return _QagListLoadingViewModel();
    } else if (state is QagListSuccessState) {
      final header = state.header != null
          ? _QagListHeaderViewModel(
              id: state.header!.id,
              title: state.header!.title,
              message: state.header!.message,
            )
          : null;

      if (state.qags.isNotEmpty) {
        return _QagListWithResultViewModel(
          qags: QagPresenter.presentQag(state.qags),
          header: header,
          hasFooter: state.currentPage < state.maxPage,
          footerType: state.footerType,
        );
      } else {
        return _QagListNoResultViewModel(header: header);
      }
    } else {
      return _QagListErrorViewModel();
    }
  }
}

class _QagListLoadingViewModel extends _ViewModel {
  @override
  List<Object?> get props => [];
}

class _QagListWithResultViewModel extends _ViewModel {
  final List<QagDisplayModel> qags;
  final _QagListHeaderViewModel? header;
  final bool hasFooter;
  final QagListFooterType footerType;

  _QagListWithResultViewModel({
    required this.qags,
    required this.header,
    required this.hasFooter,
    required this.footerType,
  });

  @override
  List<Object?> get props => [qags, header, hasFooter, footerType];
}

class _QagListNoResultViewModel extends _ViewModel {
  final _QagListHeaderViewModel? header;

  _QagListNoResultViewModel({required this.header});

  @override
  List<Object?> get props => [header];
}

class _QagListErrorViewModel extends _ViewModel {
  @override
  List<Object?> get props => [];
}

class _QagListHeaderViewModel extends Equatable {
  final String id;
  final String title;
  final String message;

  _QagListHeaderViewModel({
    required this.id,
    required this.title,
    required this.message,
  });

  @override
  List<Object?> get props => [id, title, message];
}
