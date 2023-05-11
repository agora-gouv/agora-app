import 'package:equatable/equatable.dart';

class FetchQagsEvent extends Equatable {
  final String? thematiqueId;

  FetchQagsEvent({required this.thematiqueId});

  @override
  List<Object?> get props => [thematiqueId];
}
