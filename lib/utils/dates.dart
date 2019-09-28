import 'package:intl/intl.dart';

class Dates {
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  static String getTimeBefore(String original) {
    final dateTime = _dateFormat.parse(original);
    final duration = dateTime.difference(DateTime.now());
    final days = duration.inDays;
    final hours = duration.inHours - days * 24;

    String result = "In ";
    if (days > 0) {
      if (days == 1) {
        result += "$days day ";
      } else {
        result += "$days days ";
      }
    }
    if (hours >= 0) {
      result += "$hours h";
    }
    return result;
  }
}
