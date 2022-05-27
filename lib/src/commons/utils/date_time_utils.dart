import 'package:intl/intl.dart';

class DateTimeUtils {
  DateTimeUtils._();

  static int nowMilliseconds() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  static String format(int timestamp, {String? format}) {
    var now = DateTime.now();
    var date = DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);

    if (format != null) {
      return DateFormat(format, 'ko_KR').format(date);
    }

    if (now.year != date.year) {
      return DateFormat('yyyy.MM.dd HH:mm').format(date);
    }
    if (now.month != date.month || now.day != date.day) {
      return DateFormat('MM.dd HH:mm').format(date);
    }
    return DateFormat('HH:mm').format(date);
  }
}
