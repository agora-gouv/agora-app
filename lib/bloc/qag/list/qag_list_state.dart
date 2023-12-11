import 'package:agora/bloc/qag/qag_list_footer_type.dart';
import 'package:agora/domain/qag/qag.dart';
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
  final int maxPage;
  final QagListFooterType footerType;

  QagListLoadedState({
    required super.currentPage,
    required this.qags,
    required this.maxPage,
    required this.footerType,
  });

  @override
  List<Object?> get props => [currentPage, qags, maxPage, footerType];
}

class QagListErrorState extends QagListState {
  QagListErrorState({required super.currentPage});
}
