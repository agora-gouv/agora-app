import 'package:equatable/equatable.dart';

class QagSupport extends Equatable {
  final String qagId;
  final bool isSupported;
  final int supportCount;

  QagSupport({required this.qagId, required this.isSupported, required this.supportCount});

  @override
  List<Object?> get props => [qagId, isSupported, supportCount];
}
