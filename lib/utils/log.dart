import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

enum LogType { d, e }

class Log {
  static final DateFormat _dateFormat = DateFormat('dd-MM-yyyy–HH:mm:ss:ms');

  static void d(String tag, Object message) {
    log(LogType.d, tag, message);
  }

  static void e(String tag, Object message) {
    log(LogType.e, tag, message);
  }

  static void log(LogType type, String tag, Object message) {
    String date = _dateFormat.format(DateTime.now());
    debugPrint("$date [$tag]: $message");
  }
}
