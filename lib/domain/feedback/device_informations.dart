import 'package:equatable/equatable.dart';

class DeviceInformations extends Equatable {
  final String appVersion;
  final String model;
  final String osVersion;

  DeviceInformations({
    required this.appVersion,
    required this.model,
    required this.osVersion,
  });

  @override
  List<Object?> get props => [];
}
