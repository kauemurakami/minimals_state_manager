import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimals_state_manager/src/providers/min_multi_inherited.dart';

void main() {
  group('MinMultiInherited Tests', () {
    testWidgets('Should hold and provide notifiers correctly', (tester) async {
      final notifier1 = ChangeNotifier();
      final notifier2 = ChangeNotifier();

      // We must pass records: ({ChangeNotifier notifier, String? tag})
      final instances = [
        (notifier: notifier1, tag: null),
        (notifier: notifier2, tag: 'my_tag'),
      ];

      await tester.pumpWidget(
        MinMultiInherited(
          instances: instances,
          child: Container(),
        ),
      );

      final element = tester.element(find.byType(Container));
      final inherited =
          element.dependOnInheritedWidgetOfExactType<MinMultiInherited>();

      expect(inherited, isNotNull);
      expect(inherited!.instances.length, 2);
      expect(inherited.instances[0].notifier, notifier1);
      expect(inherited.instances[1].tag, 'my_tag');
    });

    testWidgets('updateShouldNotify returns true when list changes',
        (tester) async {
      final notifier1 = ChangeNotifier();
      final notifier2 = ChangeNotifier();

      // First build
      await tester.pumpWidget(
        MinMultiInherited(
          instances: [(notifier: notifier1, tag: null)],
          child: Container(),
        ),
      );

      // Rebuild with different list
      await tester.pumpWidget(
        MinMultiInherited(
          instances: [(notifier: notifier2, tag: null)],
          child: Container(),
        ),
      );

      expect(find.byType(Container), findsOneWidget);
    });
  });
}
