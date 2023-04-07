import 'package:equatable/equatable.dart';

class FetchConsultationDetailsEvent extends Equatable {
  final String consultationId;

  FetchConsultationDetailsEvent({required this.consultationId});

  @override
  List<Object> get props => [consultationId];
}
