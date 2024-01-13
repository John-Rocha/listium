import 'package:intl/intl.dart';

class DateFormatUtils {
  static String formatDateFromISO8601ToString(String date) {
    final DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }
}
