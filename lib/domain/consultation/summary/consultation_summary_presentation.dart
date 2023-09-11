import 'package:equatable/equatable.dart';

class ConsultationSummaryPresentation extends Equatable {
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final String tipDescription;

  ConsultationSummaryPresentation({
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.tipDescription,
  });

  @override
  List<Object?> get props => [startDate, endDate, description, tipDescription];
}
