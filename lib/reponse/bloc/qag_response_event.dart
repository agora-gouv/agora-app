import 'package:equatable/equatable.dart';

class FetchQagsResponseEvent extends Equatable {
  final bool forceRefresh;

  FetchQagsResponseEvent({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}
