import 'package:equatable/equatable.dart';

class FetchConsultationQuestionsEvent extends Equatable {
  final String consultationId;

  FetchConsultationQuestionsEvent({required this.consultationId});

  @override
  List<Object> get props => [consultationId];
}
