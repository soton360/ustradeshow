import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ustradeshow/core/services/app_update_service.dart';
import 'package:ustradeshow/core/widgets/app_update_banner.dart';

void main() {
  group('AppUpdateBanner Widget Tests', () {
    testWidgets('Renders top update banner with icon, text and update button',
        (WidgetTester tester) async {
      bool updatedTapped = false;

      const testResult = UpdateResult(
        isUpdateAvailable: true,
        currentVersion: '1.0.0',
        latestVersion: '1.0.1',
        isForceUpdate: false,
        storeUrl:
            'https://play.google.com/store/apps/details?id=com.amcham.ustradeshow',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppUpdateBanner(
              updateResult: testResult,
              onUpdate: () {
                updatedTapped = true;
              },
            ),
          ),
        ),
      );

      expect(
        find.textContaining('New update available', findRichText: true),
        findsOneWidget,
      );
      expect(
        find.textContaining('Version 1.0.1', findRichText: true),
        findsOneWidget,
      );
      expect(find.text('Update'), findsOneWidget);
      expect(find.byIcon(Icons.system_update_rounded), findsOneWidget);

      await tester.tap(find.text('Update'));
      await tester.pumpAndSettle();
      expect(updatedTapped, isTrue);
    });
  });
}
