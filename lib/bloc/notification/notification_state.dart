import 'package:equatable/equatable.dart';

abstract class NotificationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotificationInitialState extends NotificationState {}

class AutoAskNotificationConsentState extends NotificationState {}

class AskNotificationConsentState extends NotificationState {}
