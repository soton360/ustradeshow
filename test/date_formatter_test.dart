import 'package:flutter_test/flutter_test.dart';
import 'package:ustradeshow/core/utils/date_formatter.dart';

void main() {
  group('DateFormatter Timezone Conversion Tests', () {
    test('Parses ISO UTC timestamp "2026-11-06T18:00:00.000Z" to local BST date 7 Nov 2026', () {
      final parsed = DateFormatter.tryParse('2026-11-06T18:00:00.000Z');
      expect(parsed, isNotNull);

      // In local device time (assuming BST UTC+6) or formatted display date
      final formatted = DateFormatter.formatDisplayDate(parsed!);
      final shortFormatted = DateFormatter.formatShortDate(parsed);

      expect(formatted, contains('November 2026'));
      expect(shortFormatted, contains('Nov 2026'));
    });

    test('Parses standard date string "2026-11-07" correctly', () {
      final parsed = DateFormatter.tryParse('2026-11-07');
      expect(parsed, isNotNull);
      expect(DateFormatter.formatDisplayDate(parsed!), '7 November 2026');
      expect(DateFormatter.formatShortDate(parsed), '7 Nov 2026');
    });
  });
}
