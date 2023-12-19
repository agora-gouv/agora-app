import 'package:agora/domain/qag/qag_support.dart';
import 'package:equatable/equatable.dart';

abstract class QagSearchEvent extends Equatable {}

class FetchQagsInitialEvent extends QagSearchEvent {
  @override
  List<Object?> get props => [];
}

class FetchQagsLoadingEvent extends QagSearchEvent {
  @override
  List<Object?> get props => [];
}

class FetchQagsSearchEvent extends QagSearchEvent {
  final String keywords;

  FetchQagsSearchEvent({required this.keywords});

  @override
  List<Object?> get props => [keywords];
}

class UpdateQagSearchSupportEvent extends QagSearchEvent {
  final QagSupport qagSupport;

  UpdateQagSearchSupportEvent(this.qagSupport);

  factory UpdateQagSearchSupportEvent.create({
    required final String qagId,
    required final bool isSupported,
    required final int supportCount,
  }) {
    return UpdateQagSearchSupportEvent(QagSupport(qagId: qagId, isSupported: isSupported, supportCount: supportCount));
  }

  @override
  List<Object?> get props => [qagSupport];
}
