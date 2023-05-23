abstract class JwtHelper {
  String? getJwtToken();
  void setJwtToken(String jwtToken);
}

class JwtHelperImpl extends JwtHelper {
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
