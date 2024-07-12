import 'package:equatable/equatable.dart';

abstract class QagSupportEvent extends Equatable {
  final String qagId;

  QagSupportEvent({required this.qagId});

  @override
  List<Object> get props => [qagId];
}

class SupportQagEvent extends QagSupportEvent {
  SupportQagEvent({required super.qagId});
}

class DeleteSupportQagEvent extends QagSupportEvent {
  DeleteSupportQagEvent({required super.qagId});

  @override
  List<Object> get props => [qagId];
}
