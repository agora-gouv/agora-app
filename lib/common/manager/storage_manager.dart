import 'package:agora/common/manager/helper_manager.dart';
import 'package:agora/common/storage/secure_storage_client.dart';
import 'package:agora/qag/repository/header_qag_repository.dart';
import 'package:agora/profil/notification/repository/notification_first_request_permission_storage_client.dart';
import 'package:agora/profil/onboarding/repository/onboarding_storage_client.dart';
import 'package:agora/profil/demographic/repository/demographic_storage_client.dart';
import 'package:agora/login/repository/login_storage_client.dart';
import 'package:agora/consultation/question/repository/consultation_question_storage_client.dart';
import 'package:agora/push_notification/push_notification_storage_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  static SecureStorageClient _getSecureStorageClient(SharedPreferences sharedPref) {
    if (GetIt.instance.isRegistered<FlutterSecureStorageClient>()) {
      return GetIt.instance.get<FlutterSecureStorageClient>();
    }
    final client = FlutterSecureStorageClient(
      secureStorage: FlutterSecureStorage(),
      sharedPref: sharedPref,
      sentryWrapper: HelperManager.getSentryWrapper(),
    );
    GetIt.instance.registerSingleton(client);
    return client;
  }

  static NotificationFirstRequestPermissionStorageClient getFirstConnectionStorageClient() {
    if (GetIt.instance.isRegistered<NotificationFirstRequestPermissionSharedPreferencesClient>()) {
      return GetIt.instance.get<NotificationFirstRequestPermissionSharedPreferencesClient>();
    }
    final storage = NotificationFirstRequestPermissionSharedPreferencesClient();
    GetIt.instance.registerSingleton(storage);
    return storage;
  }

  static LoginStorageClient getLoginStorageClient({SharedPreferences? sharedPref}) {
    if (GetIt.instance.isRegistered<LoginSharedPreferencesClient>()) {
      return GetIt.instance.get<LoginSharedPreferencesClient>();
    }
    final storage = LoginSharedPreferencesClient(secureStorageClient: _getSecureStorageClient(sharedPref!));
    GetIt.instance.registerSingleton(storage);
    return storage;
  }

  static OnboardingStorageClient getOnboardingStorageClient() {
    if (GetIt.instance.isRegistered<OnboardingSharedPreferencesClient>()) {
      return GetIt.instance.get<OnboardingSharedPreferencesClient>();
    }
    final storage = OnboardingSharedPreferencesClient();
    GetIt.instance.registerSingleton(storage);
    return storage;
  }

  static PushNotificationStorageClient getPushNotificationStorageClient() {
    if (GetIt.instance.isRegistered<PushNotificationSharedPreferencesClient>()) {
      return GetIt.instance.get<PushNotificationSharedPreferencesClient>();
    }
    final storage = PushNotificationSharedPreferencesClient();
    GetIt.instance.registerSingleton(storage);
    return storage;
  }

  static DemographicStorageClient getProfileDemographicStorageClient() {
    if (GetIt.instance.isRegistered<ProfileDemographicSharedPreferencesClient>()) {
      return GetIt.instance.get<ProfileDemographicSharedPreferencesClient>();
    }
    final storage = ProfileDemographicSharedPreferencesClient();
    GetIt.instance.registerSingleton(storage);
    return storage;
  }

  static ConsultationQuestionStorageClient getConsultationQuestionStorageClient() {
    if (GetIt.instance.isRegistered<ConsultationQuestionHiveStorageClient>()) {
      return GetIt.instance.get<ConsultationQuestionHiveStorageClient>();
    }
    final helper = ConsultationQuestionHiveStorageClient();
    GetIt.instance.registerSingleton(helper);
    return helper;
  }

  static HeaderQagStorageClient getHeaderQagStorageClient() {
    if (GetIt.instance.isRegistered<HeaderQagSharedPreferencesClient>()) {
      return GetIt.instance.get<HeaderQagSharedPreferencesClient>();
    }
    final helper = HeaderQagSharedPreferencesClient();
    GetIt.instance.registerSingleton(helper);
    return helper;
  }
}
