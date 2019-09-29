import 'package:intl/intl.dart';

class Dates {
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  static String getTimeBefore(String original) {
    final dateTime = _dateFormat.parse(original);
    final duration = dateTime.difference(DateTime.now());
    final days = duration.inDays;
    final month = dateTime.month; //ЗДЕСЬ НАДО МЕСЯЦ СТРОКОЙ

    String result;
    if (dateTime.day == DateTime.now().day) {
      result = "Today";
    } else if ((dateTime.month - DateTime.now().month).abs() <= 1 && dateTime.isAfter(DateTime.now())) {
      if (dateTime.day == DateTime.now().add(Duration(days: 1)).day) {
        result = "Tomorrow";
      } else if (days > 0) {
        result = "In ";
        if (days == 1) {
          result += "$days day ";
        } else {
          result += "$days days ";
        }
      }
    } else {
      result = "In ${getMonthName(month)}";
    }

    return result;
  }

  static String getMonthName(int month) {
    switch (month) {
      case 1:
        return "January";
      case 2:
        return "February";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      case 12:
        return "December";
    }

    throw UnsupportedError("Unknown month value");
  }
}
