import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimals_state_manager/min_extensions.dart';
import 'package:minimals_state_manager/min_notifiers.dart';
import 'package:minimals_state_manager/min_providers.dart';

class HomeNotifier extends MinNotifier {
  bool disposeCalled = false;
  int counter = 0;

  void increment() {
    counter++;
    notifyListeners();
  }

  @override
  void dispose() {
    disposeCalled = true;
    super.dispose();
  }
}

class CartNotifier extends MinNotifier {}

void main() {
  /// {@template min_provider_test.injection_and_context}
  /// **Test Target:** `MinProvider` Widget Tree Injection & Extension Resolution
  ///
  /// **Objective:** Spawns a dedicated declarative `MinProvider` subtree topology
  /// to verify if consumer descendants can effortlessly pull the targeted instance
  /// via both static functional bindings and clean `BuildContext` extension utilities.
  /// {@endtemplate}
  testWidgets(
    'Should inject controller into the widget tree and resolve via BuildContext extensions',
    (WidgetTester tester) async {
      // Arrange
      final homeNotifier = HomeNotifier();

      await tester.pumpWidget(
        MaterialApp(
          home: MinProvider<HomeNotifier>(
            create: () => homeNotifier,
            child: Builder(
              builder: (context) {
                // Act
                final readController = context.read<HomeNotifier>();
                return Text('Counter: ${readController.counter}',
                    textDirection: TextDirection.ltr);
              },
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Counter: 0'), findsOneWidget);
    },
  );

  /// {@template min_provider_test.multi_provider}
  /// **Test Target:** `MinMultiProvider` Array Compaction Injection
  ///
  /// **Objective:** Tests the structural integrity of `MinMultiProvider` ensuring
  /// it sequentially builds and layers multiple distinct controllers onto the
  /// widget tree context, avoiding nested provider tree nesting pyramids entirely.
  /// {@endtemplate}
  testWidgets(
    'Should inject multiple distinct managers simultaneously using MinMultiProvider',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MinMultiProvider(
            create: [
              () => HomeNotifier(),
              () => CartNotifier(),
            ],
            child: Builder(
              builder: (context) {
                // Act
                final home = context.read<HomeNotifier>();
                final cart = context.read<CartNotifier>();

                // Assert
                expect(home, isA<HomeNotifier>());
                expect(cart, isA<CartNotifier>());
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
    },
  );

  /// {@template min_provider_test.auto_dispose}
  /// **Test Target:** `MinProvider` Context Pop Tree Garbage Collection & Disposal
  ///
  /// **Objective:** Emulates physical screen routing shifts. When a route housing a
  /// `MinProvider` segment is permanently detached and popped from the Flutter tree,
  /// the underlying framework must trigger the controller's internal `dispose()` automatically.
  /// {@endtemplate}
  testWidgets(
    'Should trigger controller disposal automatically when the provider is removed from tree',
    (WidgetTester tester) async {
      // Arrange
      final homeNotifier = HomeNotifier();
      bool showProvider = true;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  if (showProvider)
                    MinProvider<HomeNotifier>(
                      create: () => homeNotifier,
                      child: const Text('Active Node'),
                    ),
                  ElevatedButton(
                    onPressed: () => setState(() => showProvider = false),
                    child: const Text('Kill Provider'),
                  ),
                ],
              );
            },
          ),
        ),
      );

      expect(homeNotifier.disposeCalled, isFalse);

      // Act
      await tester.tap(find.text('Kill Provider'));
      await tester.pumpAndSettle(); // Forces widget tree structural refresh

      // Assert
      expect(homeNotifier.disposeCalled, isTrue);
    },
  );
}
