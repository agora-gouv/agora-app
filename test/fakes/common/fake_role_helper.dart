import 'package:agora/common/helper/role_helper.dart';

class FakeRoleHelper extends RoleHelper {
  bool? _isModerator;

  @override
  bool? isModerator() {
    return _isModerator;
  }

  @override
  void setIsModerator(bool isModerator) {
    _isModerator = isModerator;
  }
}
