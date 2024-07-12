import 'package:agora/profil/demographic/repository/demographic_storage_client.dart';

class FakeProfileDemographicStorageClient extends DemographicStorageClient {
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
