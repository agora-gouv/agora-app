import 'package:equatable/equatable.dart';

class DemographicResponse extends Equatable {
  final String question;
  final String response;

  DemographicResponse({
    required this.question,
    required this.response,
  });

  @override
  List<Object> get props => [question, response];
}
