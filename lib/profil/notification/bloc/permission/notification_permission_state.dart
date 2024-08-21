import 'package:equatable/equatable.dart';

abstract class NotificationPermissionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotificationPermissionInitialState extends NotificationPermissionState {}

class AutoAskNotificationConsentState extends NotificationPermissionState {}

class AskNotificationConsentState extends NotificationPermissionState {}
