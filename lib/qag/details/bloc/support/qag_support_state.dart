import 'package:equatable/equatable.dart';

abstract class QagSupportState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QagSupportInitialState extends QagSupportState {}

class QagSupportLoadingState extends QagSupportState {}

class QagSupportSuccessState extends QagSupportState {
  final String qagId;
  final bool isSupported;
  final int supportCount;

  QagSupportSuccessState({
    required this.qagId,
    required this.isSupported,
    required this.supportCount,
  });

  @override
  List<Object> get props => [qagId, isSupported, supportCount];
}

class QagSupportErrorState extends QagSupportState {
  final String qagId;

  QagSupportErrorState({required this.qagId});

  @override
  List<Object> get props => [qagId];
}
