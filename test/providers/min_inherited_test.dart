import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimals_state_manager/src/providers/min_inherited.dart';

/// Dummy Notifier for testing.
class TestNotifier extends ChangeNotifier {
  int value = 0;
  void increment() {
    value++;
    notifyListeners();
  }
}

void main() {
  group('MinInherited Tests', () {
    testWidgets('Should provide the notifier to descendants', (tester) async {
      final notifier = TestNotifier();

      await tester.pumpWidget(
        MinInherited<TestNotifier>(
          notifier: notifier,
          child: Container(),
        ),
      );

      // Verify the widget is in the tree
      final element = tester.element(find.byType(Container));
      final inherited = element
          .dependOnInheritedWidgetOfExactType<MinInherited<TestNotifier>>();

      expect(inherited, isNotNull);
      expect(inherited!.notifier, equals(notifier));
    });

    testWidgets('Should trigger rebuild when notifier calls notifyListeners',
        (tester) async {
      final notifier = TestNotifier();
      int rebuildCount = 0;

      await tester.pumpWidget(
        MinInherited<TestNotifier>(
          notifier: notifier,
          child: Builder(builder: (context) {
            // Register dependency
            context.dependOnInheritedWidgetOfExactType<
                MinInherited<TestNotifier>>();
            rebuildCount++;
            return Container();
          }),
        ),
      );

      expect(rebuildCount, 1);

      // Act: Trigger notification
      notifier.increment();
      await tester.pump();

      // Assert: Widget should have rebuilt
      expect(rebuildCount, 2);
    });
  });
}
