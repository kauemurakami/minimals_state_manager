import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimals_state_manager/minimals_state_manager.dart';

/// Dummy class for testing [MinProvider] lifecycle and state.
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
    testWidgets('Should execute lifecycle hooks and inject controller',
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
      // Wait for postFrameCallback
      await tester.pump();
      expect(notifier.onReadyCalled, isTrue);
    });

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

    testWidgets('Should dispose controller when provider is removed',
        (tester) async {
      // Arrange: Create your controller
      final notifier = TestNotifier();

      // Act: Mount the provider in the tree
      await tester.pumpWidget(
        MinProvider(
          create: () => notifier,
          child: Container(),
        ),
      );

      // Verify it's mounted
      expect(find.byType(Container), findsOneWidget);

      // Act: Force removal by pumping an empty Container
      // This triggers the dispose() method in the State class of MinProvider
      await tester.pumpWidget(Container());

      // Assert: Check if the controller was disposed
      expect(notifier.disposeCalled, isTrue);
    });

    testWidgets('Read/Watch should throw error if not found', (tester) async {
      await tester.pumpWidget(Builder(builder: (context) {
        expect(() => MinProvider.read<TestNotifier>(context),
            throwsAssertionError);
        expect(() => MinProvider.watch<TestNotifier>(context),
            throwsAssertionError);
        return Container();
      }));
    });
  });
}
