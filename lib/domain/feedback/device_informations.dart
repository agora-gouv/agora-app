import 'package:equatable/equatable.dart';

class DeviceInformation extends Equatable {
  final String appVersion;
  final String model;
  final String osVersion;

  DeviceInformation({
    required this.appVersion,
    required this.model,
    required this.osVersion,
  });

  @override
  List<Object?> get props => [appVersion, model, osVersion];
}
