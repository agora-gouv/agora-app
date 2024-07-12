import 'package:agora/qag/domain/header_qag.dart';
import 'package:agora/qag/domain/qag.dart';
import 'package:agora/qag/list/bloc/qag_list_bloc.dart';
import 'package:equatable/equatable.dart';

abstract class QagListState extends Equatable {
  final int currentPage;

  QagListState({required this.currentPage});

  @override
  List<Object?> get props => [currentPage];
}

class QagListInitialState extends QagListState {
  QagListInitialState() : super(currentPage: 1);
}

class QagListLoadedState extends QagListState {
  final List<Qag> qags;
  final HeaderQag? header;
  final int maxPage;
  final QagListFooterType footerType;

  QagListLoadedState({
    required super.currentPage,
    required this.qags,
    required this.header,
    required this.maxPage,
    required this.footerType,
  });

  factory QagListLoadedState.copyWith({
    required QagListLoadedState state,
    int? currentPage,
    List<Qag>? qags,
    HeaderQag? header,
    int? maxPage,
    QagListFooterType? footerType,
  }) {
    return QagListLoadedState(
      currentPage: currentPage != state.currentPage && currentPage != null ? currentPage : state.currentPage,
      qags: qags != state.qags && qags != null ? qags : state.qags,
      header: header != state.header ? header : state.header,
      maxPage: maxPage != state.maxPage && maxPage != null ? maxPage : state.maxPage,
      footerType: footerType != state.footerType && footerType != null ? footerType : state.footerType,
    );
  }

  @override
  List<Object?> get props => [
        currentPage,
        qags,
        header,
        maxPage,
        footerType,
      ];
}

class QagListErrorState extends QagListState {
  QagListErrorState({required super.currentPage});
}
