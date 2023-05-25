abstract class RoleHelper {
  bool? isModerator();

  void setIsModerator(bool isModerator);
}

class RoleHelperImpl extends RoleHelper {
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
