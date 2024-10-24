import 'package:equatable/equatable.dart';

class QagContentDto extends Equatable {
  final String info;
  final String texteTotalQuestions;

  QagContentDto({required this.info, required this.texteTotalQuestions});

  @override
  List<Object?> get props => [info, texteTotalQuestions];
}
