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

class QagListLoadingState extends QagListState {
  QagListLoadingState() : super(currentPage: 1);
}

class QagListSuccessState extends QagListState {
  final List<Qag> qags;
  final HeaderQag? header;
  final int maxPage;
  final QagListFooterType footerType;

  QagListSuccessState({
    required super.currentPage,
    required this.qags,
    required this.header,
    required this.maxPage,
    required this.footerType,
  });

  factory QagListSuccessState.copyWith({
    required QagListSuccessState state,
    int? currentPage,
    List<Qag>? qags,
    HeaderQag? header,
    int? maxPage,
    QagListFooterType? footerType,
  }) {
    return QagListSuccessState(
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
