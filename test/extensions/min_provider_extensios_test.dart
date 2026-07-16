import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimals_state_manager/minimals_state_manager.dart';

/// Dummy class to act as our state manager for testing purposes.
class TestNotifier extends MinNotifier {
  int value = 0;
  void increment() {
    value++;
    notifyListeners();
  }
}

class RegisteredNotifier extends ChangeNotifier {}

class MissingNotifier extends MinNotifier {}

void main() {
  group('ProviderExtension Tests', () {
    /// {@template min_provider_extensions_test.watch_min_inherited}
    /// **Test Target:** `watch` via `MinProvider`
    ///
    /// **Objective:** Verifies that [watch] correctly retrieves a notifier
    /// from the single-provider [MinProvider] hierarchy.
    /// {@endtemplate}
    testWidgets('watch should retrieve from MinInherited', (tester) async {
      final controller = TestNotifier();

      await tester.pumpWidget(
        MinProvider(
          create: () => controller,
          child: Builder(builder: (context) {
            final found = context.watch<TestNotifier>();
            expect(found, controller);
            return Container();
          }),
        ),
      );
    });

    /// {@template min_provider_extensions_test.watch_multi_provider}
    /// **Test Target:** `watch` via `MinMultiProvider`
    ///
    /// **Objective:** Verifies that [watch] correctly retrieves a notifier
    /// from the `MinMultiProvider` registry.
    /// {@endtemplate}
    testWidgets('watch should retrieve from MinMultiProvider', (tester) async {
      final controller = TestNotifier();

      await tester.pumpWidget(
        MinMultiProvider(
          create: [() => controller],
          child: Builder(builder: (context) {
            final found = context.watch<TestNotifier>();
            expect(found, controller);
            return Container();
          }),
        ),
      );
    });

    /// {@template min_provider_extensions_test.watch_not_found}
    /// **Test Target:** `watch` Not Found Error
    ///
    /// **Objective:** Assures that attempting to [watch] a notifier when no
    /// provider is present in the tree throws an [Exception].
    /// {@endtemplate}
    testWidgets('watch should throw exception when not found', (tester) async {
      await tester.pumpWidget(
        Builder(builder: (context) {
          expect(() => context.watch<TestNotifier>(), throwsException);
          return Container();
        }),
      );
    });

    /// {@template min_provider_extensions_test.read_min_inherited}
    /// **Test Target:** `read` via `MinProvider`
    ///
    /// **Objective:** Verifies that [read] correctly retrieves a notifier
    /// from the single-provider [MinProvider] hierarchy.
    /// {@endtemplate}
    testWidgets('read should retrieve from MinInherited', (tester) async {
      final controller = TestNotifier();

      await tester.pumpWidget(
        MinProvider(
          create: () => controller,
          child: Builder(builder: (context) {
            final found = context.read<TestNotifier>();
            expect(found, controller);
            return Container();
          }),
        ),
      );
    });

    /// {@template min_provider_extensions_test.read_multi_provider}
    /// **Test Target:** `read` via `MinMultiProvider`
    ///
    /// **Objective:** Verifies that [read] correctly retrieves a notifier
    /// from the `MinMultiProvider` registry.
    /// {@endtemplate}
    testWidgets('read should retrieve from MinMultiProvider', (tester) async {
      final controller = TestNotifier();

      await tester.pumpWidget(
        MinMultiProvider(
          create: [() => controller],
          child: Builder(builder: (context) {
            final found = context.read<TestNotifier>();
            expect(found, controller);
            return Container();
          }),
        ),
      );
    });

    /// {@template min_provider_extensions_test.read_not_found}
    /// **Test Target:** `read` Not Found Error
    ///
    /// **Objective:** Assures that attempting to [read] a notifier when no
    /// provider is present in the tree throws an [Exception].
    /// {@endtemplate}
    testWidgets('read should throw exception when not found', (tester) async {
      await tester.pumpWidget(
        Builder(builder: (context) {
          expect(() => context.read<TestNotifier>(), throwsException);
          return Container();
        }),
      );
    });

    /// {@template min_provider_extensions_test.read_missing_in_multi}
    /// **Test Target:** `read` Missing Type in MultiProvider
    ///
    /// **Objective:** Verifies that requesting an unregistered type via [read]
    /// within a `MinMultiProvider` throws the expected [Exception].
    /// {@endtemplate}
    testWidgets(
        'Read should throw Exception if type is missing in MultiProvider',
        (tester) async {
      await tester.pumpWidget(
        MinMultiProvider(
          create: [() => RegisteredNotifier()],
          child: Builder(builder: (context) {
            expect(() => context.read<MissingNotifier>(), throwsException);
            return Container();
          }),
        ),
      );
    });

    /// {@template min_provider_extensions_test.watch_missing_in_multi}
    /// **Test Target:** `watch` Missing Type in MultiProvider
    ///
    /// **Objective:** Verifies that requesting an unregistered type via [watch]
    /// within a `MinMultiProvider` tree also throws the expected [Exception].
    /// {@endtemplate}
    testWidgets(
        'Watch should throw Exception if type is missing in MultiProvider',
        (tester) async {
      await tester.pumpWidget(
        MinMultiProvider(
          create: [() => RegisteredNotifier()],
          child: Builder(builder: (context) {
            expect(() => context.watch<MissingNotifier>(), throwsException);
            return Container();
          }),
        ),
      );
    });
  });
}
