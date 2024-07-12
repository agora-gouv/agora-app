import 'package:agora/profil/notification/bloc/get/notification_view_model.dart';
import 'package:equatable/equatable.dart';

sealed class NotificationState extends Equatable {
  final bool hasMoreNotifications;
  final List<NotificationViewModel> notificationViewModels;
  final int currentPageNumber;

  NotificationState({
    required this.notificationViewModels,
    required this.currentPageNumber,
    required this.hasMoreNotifications,
  });

  @override
  List<Object> get props => [notificationViewModels, currentPageNumber, hasMoreNotifications];
}

class NotificationInitialState extends NotificationState {
  NotificationInitialState() : super(notificationViewModels: [], currentPageNumber: -1, hasMoreNotifications: false);
}

class NotificationLoadingState extends NotificationState {
  NotificationLoadingState({
    required super.notificationViewModels,
    required super.currentPageNumber,
    required super.hasMoreNotifications,
  });
}

class NotificationFetchedState extends NotificationState {
  NotificationFetchedState({
    required super.notificationViewModels,
    required super.currentPageNumber,
    required super.hasMoreNotifications,
  });
}

class NotificationErrorState extends NotificationState {
  NotificationErrorState({
    required super.notificationViewModels,
    required super.currentPageNumber,
    required super.hasMoreNotifications,
  });
}
