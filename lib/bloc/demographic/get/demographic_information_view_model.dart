import 'package:equatable/equatable.dart';

class DemographicInformationViewModel extends Equatable {
  final String demographicType;
  final String data;

  DemographicInformationViewModel({
    required this.demographicType,
    required this.data,
  });

  @override
  List<Object> get props => [demographicType, data];
}
