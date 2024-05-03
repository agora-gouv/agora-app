import 'package:agora/domain/consultation/questions/consultation_question.dart';
import 'package:equatable/equatable.dart';

class ConsultationQuestions extends Equatable {
  final int questionCount;
  final List<ConsultationQuestion> questions;

  ConsultationQuestions({required this.questionCount, required this.questions});

  @override
  List<Object?> get props => [questionCount, questions];
}
