import 'package:agora/common/helper/jwt_helper.dart';

class FakeJwtHelper extends JwtHelper {
  String? _jwtToken;

  @override
  String? getJwtToken() {
    return _jwtToken;
  }

  @override
  void setJwtToken(String jwtToken) {
    _jwtToken = jwtToken;
  }
}
