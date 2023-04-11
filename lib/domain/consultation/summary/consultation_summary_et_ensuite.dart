import 'package:equatable/equatable.dart';

class ConsultationSummaryEtEnsuite extends Equatable {
  final int step;
  final String description;

  ConsultationSummaryEtEnsuite({
    required this.step,
    required this.description,
  });

  @override
  List<Object> get props => [step, description];
}
