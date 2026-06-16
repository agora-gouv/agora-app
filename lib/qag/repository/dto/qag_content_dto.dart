import 'package:equatable/equatable.dart';

class QagContentDto extends Equatable {
  final String info;
  final String texteTotalQuestions;
  final String programmeDuMois;
  final String commentCaMarche;

  QagContentDto({
    required this.info,
    required this.texteTotalQuestions,
    required this.programmeDuMois,
    required this.commentCaMarche,
  });

  @override
  List<Object?> get props => [info, texteTotalQuestions, programmeDuMois, commentCaMarche];
}
