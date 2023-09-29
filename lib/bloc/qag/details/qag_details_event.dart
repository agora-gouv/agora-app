import 'package:equatable/equatable.dart';

class FetchQagDetailsEvent extends Equatable {
  final String qagId;

  FetchQagDetailsEvent({required this.qagId});

  @override
  List<Object> get props => [qagId];
}
