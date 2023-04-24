import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String formatToDayMonth() {
    return DateFormat("d MMMM").format(this);
  }
}

extension DateTimeStringExtension on String {
  DateTime parseToDateTime() {
    return DateTime.parse(this);
  }
}
