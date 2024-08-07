import 'package:agora/consultation/question/domain/consultation_question.dart';
import 'package:equatable/equatable.dart';

class ConsultationQuestions extends Equatable {
  final int questionCount;
  final List<ConsultationQuestion> questions;

  ConsultationQuestions({required this.questionCount, required this.questions});

  @override
  List<Object?> get props => [questionCount, questions];
}
