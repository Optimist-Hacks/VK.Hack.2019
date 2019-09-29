import 'package:intl/intl.dart';

class Dates {
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  static String getTimeBefore(String original) {
    final dateTime = _dateFormat.parse(original);
    final duration = dateTime.difference(DateTime.now());
    final days = duration.inDays;

    if (dateTime.day == DateTime.now().day) {
      return "Today";
    }

    if (dateTime.day == DateTime.now().add(Duration(days: 1)).day) {
      return "Tomorrow";
    }

    String result = "In ";
    if (days > 0) {
      if (days == 1) {
        result += "$days day ";
      } else {
        result += "$days days ";
      }
    }

    return result;
  }
}
