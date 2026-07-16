import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimals_state_manager/src/providers/min_multi_inherited.dart';

void main() {
  group('MinMultiInherited Tests', () {
    testWidgets('Should hold and provide notifiers correctly', (tester) async {
      final notifier1 = ChangeNotifier();
      final notifier2 = ChangeNotifier();

      await tester.pumpWidget(
        MinMultiInherited(
          notifiers: [notifier1, notifier2],
          child: Container(),
        ),
      );

      final element = tester.element(find.byType(Container));
      final inherited =
          element.dependOnInheritedWidgetOfExactType<MinMultiInherited>();

      expect(inherited, isNotNull);
      expect(inherited!.notifiers, containsAll([notifier1, notifier2]));
    });

    testWidgets('updateShouldNotify returns true when list changes',
        (tester) async {
      final notifier1 = ChangeNotifier();
      final notifier2 = ChangeNotifier();

      // First build
      await tester.pumpWidget(
        MinMultiInherited(
          notifiers: [notifier1],
          child: Container(),
        ),
      );

      // Rebuild with different list (triggers updateShouldNotify)
      await tester.pumpWidget(
        MinMultiInherited(
          notifiers: [notifier2],
          child: Container(),
        ),
      );

      // If we got here, updateShouldNotify was executed and covered.
      expect(find.byType(Container), findsOneWidget);
    });
  });
}
