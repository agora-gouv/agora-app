import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/qag/domain/header_qag.dart';
import 'package:agora/qag/domain/qag.dart';
import 'package:agora/qag/list/bloc/qag_list_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:optional/optional.dart';

class QagListState extends Equatable {
  final AllPurposeStatus status;
  final List<Qag> qags;
  final HeaderQag? header;
  final int maxPage;
  final QagListFooterType footerType;
  final int currentPage;

  QagListState({
    required this.status,
    required this.qags,
    required this.header,
    required this.maxPage,
    required this.footerType,
    required this.currentPage,
  });

  QagListState.init()
      : status = AllPurposeStatus.notLoaded,
        qags = [],
        header = null,
        maxPage = 0,
        footerType = QagListFooterType.loading,
        currentPage = 1;

  QagListState clone({
    AllPurposeStatus? status,
    List<Qag>? qags,
    Optional<HeaderQag>? headerOptional,
    int? maxPage,
    QagListFooterType? footerType,
    int? currentPage,
  }) {
    return QagListState(
      status: status ?? this.status,
      qags: qags ?? this.qags,
      header: headerOptional != null ? headerOptional.orElseNullable(null) : header,
      maxPage: maxPage ?? this.maxPage,
      footerType: footerType ?? this.footerType,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [status, qags, header, maxPage, footerType, currentPage];
}
