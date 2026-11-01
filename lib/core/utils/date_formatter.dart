import 'package:intl/intl.dart';

/// Date and time formatting helpers.
class DateFormatter {
  DateFormatter._();

  static String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String formatDisplayDate(DateTime date) {
    return DateFormat('d MMMM yyyy').format(date);
  }

  static String formatShortDate(DateTime date) {
    return DateFormat('d MMM yyyy').format(date);
  }

  static DateTime? tryParse(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    final parsed = DateTime.tryParse(dateStr);
    if (parsed == null) return null;
    // If the input string contains full ISO time with UTC 'Z' offset (e.g. "2026-11-06T18:00:00.000Z"),
    // convert it to local timezone (e.g. BST UTC+6 -> 2026-11-07 00:00:00) so the correct day is rendered.
    return parsed.isUtc ? parsed.toLocal() : parsed;
  }
}
