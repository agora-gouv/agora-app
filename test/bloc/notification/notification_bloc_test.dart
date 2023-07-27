import 'package:agora/bloc/notification/get/notification_bloc.dart';
import 'package:agora/bloc/notification/get/notification_event.dart';
import 'package:agora/bloc/notification/get/notification_state.dart';
import 'package:agora/bloc/notification/get/notification_view_model.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../fakes/notification/fakes_notification_repository.dart';

void main() {
  Intl.defaultLocale = "fr_FR";
  initializeDateFormatting('fr_FR', null);

  group("GetNotificationEvent", () {
    blocTest(
      "when repository succeed and pageNumber is 1 - should emit success state",
      build: () => NotificationBloc(
        notificationRepository: FakeNotificationSuccessRepository(),
      ),
      act: (bloc) => bloc.add(GetNotificationEvent(pageNumber: 1)),
      expect: () => [
        NotificationLoadingState(
          hasMoreNotifications: false,
          currentPageNumber: 1,
          notificationViewModels: [],
        ),
        NotificationFetchedState(
          hasMoreNotifications: true,
          currentPageNumber: 1,
          notificationViewModels: [
            NotificationViewModel(
              title: "titre de la notification",
              type: "Consultations",
              date: "27 juillet",
            ),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest<NotificationBloc, NotificationState>(
      "when repository succeed and pageNumber is other than 1 - should emit success state",
      build: () => NotificationBloc(
        notificationRepository: FakeNotificationSuccessRepository(),
      ),
      seed: () => NotificationFetchedState(
        hasMoreNotifications: true,
        currentPageNumber: 1,
        notificationViewModels: [
          NotificationViewModel(
            title: "titre de la notification blabla",
            type: "Questions Citoyennes",
            date: "28 juillet",
          ),
        ],
      ),
      act: (bloc) => bloc.add(GetNotificationEvent(pageNumber: 2)),
      expect: () => [
        NotificationLoadingState(
          hasMoreNotifications: true,
          currentPageNumber: 2,
          notificationViewModels: [
            NotificationViewModel(
              title: "titre de la notification blabla",
              type: "Questions Citoyennes",
              date: "28 juillet",
            ),
          ],
        ),
        NotificationFetchedState(
          hasMoreNotifications: true,
          currentPageNumber: 2,
          notificationViewModels: [
            NotificationViewModel(
              title: "titre de la notification blabla",
              type: "Questions Citoyennes",
              date: "28 juillet",
            ),
            NotificationViewModel(
              title: "titre de la notification",
              type: "Consultations",
              date: "27 juillet",
            ),
          ],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed and pageNumber is 1 - should emit failure state",
      build: () => NotificationBloc(
        notificationRepository: FakeNotificationFailureRepository(),
      ),
      act: (bloc) => bloc.add(GetNotificationEvent(pageNumber: 1)),
      expect: () => [
        NotificationLoadingState(
          hasMoreNotifications: false,
          currentPageNumber: 1,
          notificationViewModels: [],
        ),
        NotificationErrorState(
          hasMoreNotifications: false,
          currentPageNumber: 1,
          notificationViewModels: [],
        ),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });

  blocTest<NotificationBloc, NotificationState>(
    "when repository failed and pageNumber is other than 1 - should emit failure state",
    build: () => NotificationBloc(
      notificationRepository: FakeNotificationFailureRepository(),
    ),
    seed: () => NotificationFetchedState(
      hasMoreNotifications: true,
      currentPageNumber: 1,
      notificationViewModels: [
        NotificationViewModel(
          title: "titre de la notification blabla",
          type: "Questions Citoyennes",
          date: "28 juillet",
        ),
      ],
    ),
    act: (bloc) => bloc.add(GetNotificationEvent(pageNumber: 2)),
    expect: () => [
      NotificationLoadingState(
        hasMoreNotifications: true,
        currentPageNumber: 2,
        notificationViewModels: [
          NotificationViewModel(
            title: "titre de la notification blabla",
            type: "Questions Citoyennes",
            date: "28 juillet",
          ),
        ],
      ),
      NotificationErrorState(
        hasMoreNotifications: true,
        currentPageNumber: 2,
        notificationViewModels: [
          NotificationViewModel(
            title: "titre de la notification blabla",
            type: "Questions Citoyennes",
            date: "28 juillet",
          ),
        ],
      ),
    ],
    wait: const Duration(milliseconds: 5),
  );
}
