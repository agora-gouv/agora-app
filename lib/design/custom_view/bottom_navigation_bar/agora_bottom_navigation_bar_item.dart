class AgoraBottomNavigationBarItem {
  final String activateIcon;
  final String inactivateIcon;
  final String label;
  final bool hasUnreadCheck;

  AgoraBottomNavigationBarItem({
    required this.activateIcon,
    required this.inactivateIcon,
    required this.label,
    this.hasUnreadCheck = false,
  });
}
