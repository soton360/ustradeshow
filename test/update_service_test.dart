import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ustradeshow/core/services/app_update_service.dart';
import 'package:ustradeshow/core/widgets/app_update_dialog.dart';

void main() {
  group('Update Version Comparison Tests', () {
    test('Detects newer version correctly', () {
      const result = UpdateResult(
        isUpdateAvailable: true,
        currentVersion: '1.0.0',
        latestVersion: '1.0.1',
        storeUrl:
            'https://play.google.com/store/apps/details?id=com.amcham.ustradeshow',
      );

      expect(result.isUpdateAvailable, isTrue);
      expect(result.currentVersion, '1.0.0');
      expect(result.latestVersion, '1.0.1');
    });

    test('Identifies up to date version', () {
      const result = UpdateResult(
        isUpdateAvailable: false,
        currentVersion: '1.0.0',
        latestVersion: '1.0.0',
        storeUrl:
            'https://play.google.com/store/apps/details?id=com.amcham.ustradeshow',
      );

      expect(result.isUpdateAvailable, isFalse);
    });
  });

  group('AppUpdateDialog Widget Tests', () {
    testWidgets('Renders AppUpdateDialog and triggers onUpdate callback',
        (WidgetTester tester) async {
      bool updatedTapped = false;

      const testResult = UpdateResult(
        isUpdateAvailable: true,
        currentVersion: '1.0.0',
        latestVersion: '1.0.2',
        isForceUpdate: false,
        storeUrl:
            'https://play.google.com/store/apps/details?id=com.amcham.ustradeshow',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppUpdateDialog(
              updateResult: testResult,
              onUpdate: () {
                updatedTapped = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('New Update Available!'), findsOneWidget);
      expect(find.text('A new version is ready for installation.'), findsOneWidget);
      expect(find.text('v1.0.0'), findsOneWidget);
      expect(find.text('v1.0.2'), findsOneWidget);

      await tester.tap(find.text('Update Now'));
      await tester.pumpAndSettle();
      expect(updatedTapped, isTrue);
    });

    testWidgets('Triggers onDismiss callback when clicking later button',
        (WidgetTester tester) async {
      bool dismissedTapped = false;

      const testResult = UpdateResult(
        isUpdateAvailable: true,
        currentVersion: '1.0.0',
        latestVersion: '1.0.2',
        isForceUpdate: false,
        storeUrl:
            'https://play.google.com/store/apps/details?id=com.amcham.ustradeshow',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppUpdateDialog(
              updateResult: testResult,
              onUpdate: () {},
              onDismiss: () {
                dismissedTapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Remind Me Later'));
      await tester.pumpAndSettle();
      expect(dismissedTapped, isTrue);
    });
  });
}
