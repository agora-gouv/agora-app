import 'package:equatable/equatable.dart';

class FetchConsultationSummaryEvent extends Equatable {
  final String consultationId;

  FetchConsultationSummaryEvent({required this.consultationId});

  @override
  List<Object> get props => [consultationId];
}
