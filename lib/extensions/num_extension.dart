import 'package:intl/intl.dart';

extension NumExtension on int {
  String convertTimestampToString() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final convertedDateTime = DateTime.fromMillisecondsSinceEpoch(this);
    final aDate = DateTime(convertedDateTime.year, convertedDateTime.month, convertedDateTime.day);
    if(aDate == today) {
      return "${convertedDateTime.hour}:${convertedDateTime.minute}";
    } else if(aDate == yesterday) {
      return "Yesterday";
    } else if (weekNumber(aDate) == weekNumber(now) && aDate.year == now.year) {
      return convertWeekDayToString(aDate.weekday);
    }
    return DateFormat('dd/MM/yyyy').format(convertedDateTime);
  }

  int weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  String convertWeekDayToString(int weekday) {
    switch (weekday) {
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      case 7:
        return "Sunday";
      default:
        return "Monday";
    }
  }
}