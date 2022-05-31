extension NumExtension on int {
  String convertTimestampToString() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final convertedDateTime = DateTime.fromMillisecondsSinceEpoch(this);
    final aDate = DateTime(convertedDateTime.year, convertedDateTime.month, convertedDateTime.day);
    if(aDate == today) {
      return "Today";
    } else if(aDate == yesterday) {
      return "Yesterday";
    }
    return aDate.toString();
  }
}