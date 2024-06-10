import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String formatToDayMonth() {
    return DateFormat("d MMM").format(this);
  }

  String formatToDayLongMonth() {
    return DateFormat("d MMMM").format(this);
  }

  String formatToDayMonthYear() {
    return DateFormat("d MMMM yyyy").format(this);
  }
}

extension DateTimeStringExtension on String {
  DateTime parseToDateTime() {
    return DateTime.parse(this);
  }
}
