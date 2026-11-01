import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ustradeshow/features/registration/presentation/widgets/day_visitor_date_picker.dart';

void main() {
  group('DayVisitorDatePicker Widget Tests', () {
    testWidgets('Renders Opening Day, Day 2, and Closing Day labels properly',
        (WidgetTester tester) async {
      String selected = '2026-11-05';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return DayVisitorDatePicker(
                  selectedDate: selected,
                  currentTime: DateTime(2026, 11, 1),
                  onDateSelected: (date) {
                    setState(() {
                      selected = date;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Select visit date'), findsOneWidget);
      expect(find.text('Opening Day'), findsOneWidget);
      expect(find.text('Day 2'), findsOneWidget);
      expect(find.text('Closing Day'), findsOneWidget);

      expect(find.text('05'), findsOneWidget);
      expect(find.text('06'), findsOneWidget);
      expect(find.text('07'), findsOneWidget);

      await tester.tap(find.text('Closing Day'));
      await tester.pumpAndSettle();

      expect(selected, '2026-11-07');
    });
  });
}
