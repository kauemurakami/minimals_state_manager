import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimals_state_manager/minimals_state_manager.dart';

/// A dummy [MinNotifier] implementation for testing lifecycle and state updates.
class TestNotifier extends MinNotifier {
  bool onInitCalled = false;
  bool onReadyCalled = false;
  bool disposeCalled = false;
  int counter = 0;

  @override
  void onInit() {
    onInitCalled = true;
  }

  @override
  void onReady() {
    onReadyCalled = true;
  }

  @override
  void dispose() {
    disposeCalled = true;
    super.dispose();
  }

  void increment() {
    counter++;
    notifyListeners();
  }
}

void main() {
  group('MinProvider Tests', () {
    /// {@template min_provider_test.lifecycle}
    /// **Test Target:** `MinProvider` Lifecycle
    ///
    /// **Objective:** Verifies that `onInit` and `onReady` are called correctly
    /// when the provider is added to the widget tree.
    /// {@endtemplate}
    testWidgets('Should execute lifecycle hooks and inject notifier',
        (tester) async {
      final notifier = TestNotifier();

      await tester.pumpWidget(
        MinProvider(
          create: () => notifier,
          child: Builder(builder: (context) {
            final read = MinProvider.read<TestNotifier>(context);
            expect(read, notifier);
            return Container();
          }),
        ),
      );

      expect(notifier.onInitCalled, isTrue);
      // Wait for postFrameCallback to trigger onReady
      await tester.pump();
      expect(notifier.onReadyCalled, isTrue);
    });

    /// {@template min_provider_test.watch}
    /// **Test Target:** `MinProvider.watch`
    ///
    /// **Objective:** Verifies that widgets rebuild when the state changes.
    /// {@endtemplate}
    testWidgets('Should watch for changes and rebuild', (tester) async {
      final notifier = TestNotifier();
      int rebuilds = 0;

      await tester.pumpWidget(
        MinProvider(
          create: () => notifier,
          child: Builder(builder: (context) {
            final watch = MinProvider.watch<TestNotifier>(context);
            rebuilds++;
            return Text('${watch.counter}', textDirection: TextDirection.ltr);
          }),
        ),
      );

      expect(rebuilds, 1);
      notifier.increment();
      await tester.pump();
      expect(rebuilds, 2);
    });

    /// {@template min_provider_test.dispose}
    /// **Test Target:** `MinProvider` Disposal
    ///
    /// **Objective:** Verifies that the notifier is disposed when the provider
    /// is removed from the tree.
    /// {@endtemplate}
    testWidgets('Should dispose notifier when provider is removed',
        (tester) async {
      final notifier = TestNotifier();

      await tester.pumpWidget(
        MinProvider(
          create: () => notifier,
          child: Container(),
        ),
      );

      expect(find.byType(Container), findsOneWidget);

      // Force removal
      await tester.pumpWidget(Container());

      expect(notifier.disposeCalled, isTrue);
    });

    /// {@template min_provider_test.error_handling}
    /// **Test Target:** `MinProvider` Error Handling
    ///
    /// **Objective:** Verifies that calling `read` or `watch` without a parent
    /// provider throws a clear [FlutterError].
    /// {@endtemplate}
    testWidgets('Read/Watch should throw FlutterError if not found',
        (tester) async {
      late BuildContext capturedContext;

      await tester.pumpWidget(
        Builder(builder: (context) {
          capturedContext = context;
          return Container();
        }),
      );

      // Verify read error
      expect(
        () => MinProvider.read<TestNotifier>(capturedContext),
        throwsA(isA<FlutterError>()),
      );

      // Verify watch error
      expect(
        () => MinProvider.watch<TestNotifier>(capturedContext),
        throwsA(isA<FlutterError>()),
      );
    });
  });
}
