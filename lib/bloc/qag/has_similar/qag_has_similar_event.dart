import 'package:equatable/equatable.dart';

class QagHasSimilarEvent extends Equatable {
  final String title;

  QagHasSimilarEvent({required this.title});

  @override
  List<Object> get props => [title];
}
