import 'package:agora/profil/notification/bloc/get/notification_event.dart';
import 'package:agora/profil/notification/bloc/get/notification_state.dart';
import 'package:agora/profil/notification/repository/notification_presenter.dart';
import 'package:agora/profil/notification/repository/notification_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationBloc extends Bloc<GetNotificationEvent, NotificationState> {
  final NotificationRepository notificationRepository;

  NotificationBloc({
    required this.notificationRepository,
  }) : super(NotificationInitialState()) {
    on<GetNotificationEvent>(_handleGetNotification);
  }

  Future<void> _handleGetNotification(
    GetNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(
      NotificationLoadingState(
        hasMoreNotifications: state.hasMoreNotifications,
        currentPageNumber: event.pageNumber,
        notificationViewModels: state.notificationViewModels,
      ),
    );
    final response = await notificationRepository.getNotifications(pageNumber: event.pageNumber);
    if (response is GetNotificationsSucceedResponse) {
      final notificationInformation = response.notificationInformation;
      final viewModels = NotificationPresenter.presentNotification(notificationInformation.notifications);
      emit(
        NotificationFetchedState(
          hasMoreNotifications: notificationInformation.hasMoreNotifications,
          currentPageNumber: event.pageNumber,
          notificationViewModels: state.notificationViewModels + viewModels,
        ),
      );
    } else {
      emit(
        NotificationErrorState(
          hasMoreNotifications: state.hasMoreNotifications,
          currentPageNumber: event.pageNumber,
          notificationViewModels: state.notificationViewModels,
        ),
      );
    }
  }
}
