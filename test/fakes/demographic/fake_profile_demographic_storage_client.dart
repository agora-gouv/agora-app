import 'package:agora/infrastructure/profile/profile_demographic_storage_client.dart';

class FakeProfileDemographicStorageClient extends ProfileDemographicStorageClient {
  bool? _isFirstTimeDisplay;

  @override
  Future<bool> isFirstDisplay() async {
    return _isFirstTimeDisplay ?? true;
  }

  @override
  void save(bool isFirstDisplay) {
    _isFirstTimeDisplay = isFirstDisplay;
  }
}
