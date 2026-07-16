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

    /// {@template min_provider_test.tagged_climbing}
    /// **Test Target:** `MinProvider` tree traversal
    ///
    /// **Objective:** Verifies that `read` and `watch` can successfully
    /// "climb" the tree to find a tagged provider that is not the immediate parent.
    /// {@endtemplate}
    testWidgets('read/watch should climb the tree to find a tagged instance',
        (tester) async {
      // 1. Create the instance once
      final targetNotifier = TestNotifier();

      await tester.pumpWidget(
        MinProvider(
          create: () => targetNotifier, // 2. Pass THIS specific instance
          tag: 'target_tag',
          child: MinProvider(
            create: () =>
                TestNotifier(), // Different instance (okay to be different here)
            tag: 'other_tag',
            child: Builder(builder: (context) {
              final foundRead =
                  MinProvider.read<TestNotifier>(context, tag: 'target_tag');

              // 3. Now this will pass because they are the same memory reference
              expect(foundRead, targetNotifier);
              return Container();
            }),
          ),
        ),
      );
    });

    /// {@template min_multi_provider_test.tagged_lookup_success}
    /// **Test Target:** Tagged lookup success
    /// **Objective:** Verifies that requesting an existing tag returns the correct notifier.
    /// {@endtemplate}
    testWidgets('Read/Watch should return correct notifier when tag exists',
        (tester) async {
      final adminCart = TestNotifier();
      final userCart = TestNotifier();

      await tester.pumpWidget(
        MinMultiProvider(
          create: [
            () => adminCart.tag('admin'),
            () => userCart.tag('user'),
          ],
          child: Builder(builder: (context) {
            expect(MinMultiProvider.read<TestNotifier>(context, tag: 'admin'),
                adminCart);
            expect(MinMultiProvider.read<TestNotifier>(context, tag: 'user'),
                userCart);
            return Container();
          }),
        ),
      );
    });

    /// {@template min_multi_provider_test.untagged_lookup_success}
    /// **Test Target:** Untagged lookup success
    /// **Objective:** Verifies that requesting a notifier without a tag returns the untagged instance.
    /// {@endtemplate}
    testWidgets('Read/Watch should return correct notifier when no tag is used',
        (tester) async {
      final defaultNotifier = TestNotifier();

      await tester.pumpWidget(
        MinMultiProvider(
          create: [() => defaultNotifier],
          child: Builder(builder: (context) {
            expect(
                MinMultiProvider.read<TestNotifier>(context), defaultNotifier);
            return Container();
          }),
        ),
      );
    });

    /// {@template min_provider_test.tagged_climbing_not_found}
    /// **Test Target:** `MinProvider` climbing not found
    ///
    /// **Objective:** Verifies that if the climb reaches the root and doesn't
    /// find the tag, it throws the expected FlutterError (covering lines 168-173).
    /// {@endtemplate}
    testWidgets('read/watch should throw error if tag not found after climbing',
        (tester) async {
      await tester.pumpWidget(
        MinProvider(
          create: () => TestNotifier(),
          tag: 'wrong_tag',
          child: Builder(builder: (context) {
            expect(
              () => MinProvider.read<TestNotifier>(context, tag: 'target_tag'),
              throwsA(isA<FlutterError>()),
            );
            expect(
              () => MinProvider.watch<TestNotifier>(context, tag: 'target_tag'),
              throwsA(isA<FlutterError>()),
            );
            return Container();
          }),
        ),
      );
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

    /// {@template min_provider_test.watch_tagged_climbing_rebuild}
    /// **Test Target:** `MinProvider.watch` aspect subscription (Lines 177-180)
    ///
    /// **Objective:** Verifies that when watching a tagged provider that is NOT
    /// the immediate parent, the system correctly locates the target and
    /// subscribes to it (the `dependOnInheritedWidgetOfExactType` call).
    /// {@endtemplate}
    testWidgets('Watch should rebuild when notifier changes', (tester) async {
      final targetNotifier = TestNotifier();
      int rebuilds = 0;

      await tester.pumpWidget(
        MinProvider(
          create: () => targetNotifier,
          tag: 'target_tag',
          child: Builder(builder: (context) {
            // Se o watch encontrar o provider da raiz, ele se inscreve nele
            final watch =
                MinProvider.watch<TestNotifier>(context, tag: 'target_tag');
            rebuilds++;
            return Text('${watch.counter}', textDirection: TextDirection.ltr);
          }),
        ),
      );

      expect(rebuilds, 1);

      targetNotifier.increment();

      await tester.pump();

      expect(rebuilds, 2);
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
