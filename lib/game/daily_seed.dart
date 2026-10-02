class DailySeed {
  DailySeed._();

  static String dateKey(DateTime date) {
    final String y = date.year.toString().padLeft(4, '0');
    final String m = date.month.toString().padLeft(2, '0');
    final String d = date.day.toString().padLeft(2, '0');
    return '$y$m$d';
  }

  static String todayKey([DateTime? now]) {
    return dateKey(now ?? DateTime.now());
  }

  static int seedFromDate(DateTime date) {
    return date.year * 10000 + date.month * 100 + date.day;
  }

  static int todaySeed([DateTime? now]) {
    return seedFromDate(now ?? DateTime.now());
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static bool isYesterday(DateTime today, DateTime other) {
    final DateTime yesterday = today.subtract(const Duration(days: 1));
    return isSameDay(yesterday, other);
  }

  static String formatDisplay(String dateKey) {
    if (dateKey.length != 8) return dateKey;
    final String y = dateKey.substring(0, 4);
    final String m = dateKey.substring(4, 6);
    final String d = dateKey.substring(6, 8);
    return '$d.$m.$y';
  }

  static DateTime parseKey(String dateKey) {
    if (dateKey.length != 8) return DateTime.now();
    return DateTime(
      int.parse(dateKey.substring(0, 4)),
      int.parse(dateKey.substring(4, 6)),
      int.parse(dateKey.substring(6, 8)),
    );
  }
}
