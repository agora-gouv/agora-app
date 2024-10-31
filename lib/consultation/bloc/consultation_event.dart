import 'package:equatable/equatable.dart';

class FetchConsultationsEvent extends Equatable {
  final bool forceRefresh;

  FetchConsultationsEvent({this.forceRefresh = false});

  @override
  List<Object> get props => [forceRefresh];
}
