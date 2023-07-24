import 'package:equatable/equatable.dart';

class QagSimilarEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetQagSimilarEvent extends QagSimilarEvent {
  final String title;

  GetQagSimilarEvent({required this.title});

  @override
  List<Object> get props => [title];
}

class UpdateSimilarQagEvent extends QagSimilarEvent {
  final String qagId;
  final int supportCount;
  final bool isSupported;

  UpdateSimilarQagEvent({
    required this.qagId,
    required this.supportCount,
    required this.isSupported,
  });

  @override
  List<Object> get props => [
        qagId,
        supportCount,
        isSupported,
      ];
}
