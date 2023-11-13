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