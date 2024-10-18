import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:agora/qag/domain/qag_response.dart';
import 'package:equatable/equatable.dart';

class QagResponseState extends Equatable {
  final AllPurposeStatus status;
  final List<QagResponseIncoming> incomingQagResponses;
  final List<QagResponse> qagResponses;

  QagResponseState({required this.status, required this.incomingQagResponses, required this.qagResponses});

  QagResponseState.init()
      : status = AllPurposeStatus.notLoaded,
        incomingQagResponses = [],
        qagResponses = [];

  QagResponseState clone({
    AllPurposeStatus? status,
    List<QagResponseIncoming>? incomingQagResponses,
    List<QagResponse>? qagResponses,
  }) {
    return QagResponseState(
      status: status ?? this.status,
      incomingQagResponses: incomingQagResponses ?? this.incomingQagResponses,
      qagResponses: qagResponses ?? this.qagResponses,
    );
  }

  @override
  List<Object> get props => [status, incomingQagResponses, qagResponses];
}
