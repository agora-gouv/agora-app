import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/qag/domain/qag_theme_hebdo.dart';
import 'package:equatable/equatable.dart';

class QagsThemeState extends Equatable {
  final AllPurposeStatus status;
  final QagThemeHebdo? qagThemeHebdo;

  QagsThemeState({
    required this.status,
    required this.qagThemeHebdo,
  });

  QagsThemeState.init()
      : status = AllPurposeStatus.loading,
        qagThemeHebdo = null;

  QagsThemeState clone({
    AllPurposeStatus? status,
    QagThemeHebdo? qagThemeHebdo,
  }) {
    return QagsThemeState(
      status: status ?? this.status,
      qagThemeHebdo: qagThemeHebdo ?? this.qagThemeHebdo,
    );
  }

  @override
  List<Object?> get props => [status, qagThemeHebdo];
}
