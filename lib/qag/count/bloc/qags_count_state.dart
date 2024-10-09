import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:equatable/equatable.dart';

class QagsCountState extends Equatable {
  final AllPurposeStatus status;
  final int count;

  QagsCountState({required this.status, required this.count});

  QagsCountState.init()
      : status = AllPurposeStatus.loading,
        count = 0;

  QagsCountState clone({AllPurposeStatus? status, int? count}) {
    return QagsCountState(
      status: status ?? this.status,
      count: count ?? this.count,
    );
  }

  @override
  List<Object?> get props => [status, count];
}
