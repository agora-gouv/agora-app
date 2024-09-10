import 'package:equatable/equatable.dart';

abstract class QagSupportEvent extends Equatable {
  final String qagId;
  final bool isSupported;
  final int supportCount;

  QagSupportEvent({required this.qagId, required this.isSupported, required this.supportCount});

  @override
  List<Object> get props => [qagId, isSupported, supportCount];
}

class SupportQagEvent extends QagSupportEvent {
  SupportQagEvent({required super.qagId, required super.isSupported, required super.supportCount});
}

class DeleteSupportQagEvent extends QagSupportEvent {
  DeleteSupportQagEvent({required super.qagId, required super.isSupported, required super.supportCount});
}
