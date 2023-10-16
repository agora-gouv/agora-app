import 'package:agora/common/helper/jwt_helper.dart';

class FakeJwtHelper extends JwtHelper {
  String? _jwtToken;
  int? _jwtExpirationEpochMilli;

  @override
  String? getJwtToken() {
    return _jwtToken;
  }

  @override
  int? getJwtExpirationEpochMilli() {
    return _jwtExpirationEpochMilli;
  }

  @override
  void setJwtToken(String jwtToken) {
    _jwtToken = jwtToken;
  }

  @override
  void setJwtExpiration(int jwtExpirationEpochMilli) {
    _jwtExpirationEpochMilli = jwtExpirationEpochMilli;
  }
}
