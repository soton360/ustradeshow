import 'package:flutter_test/flutter_test.dart';
import 'package:ustradeshow/core/di/service_locator.dart';
import 'package:ustradeshow/main.dart';

void main() {
  setUp(() {
    ServiceLocator.instance.initialize();
  });

  testWidgets('USTradeShowApp basic smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const USTradeShowApp());
    expect(find.byType(USTradeShowApp), findsOneWidget);
  });
}
