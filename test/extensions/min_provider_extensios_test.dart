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
      final notifier = TestNotifier();

      await tester.pumpWidget(
        MinProvider(
          create: () => notifier,
          child: Builder(builder: (context) {
            final found = context.watch<TestNotifier>();
            expect(found, notifier);
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
      final notifier = TestNotifier();

      await tester.pumpWidget(
        MinMultiProvider(
          create: [() => notifier],
          child: Builder(builder: (context) {
            final found = context.watch<TestNotifier>();
            expect(found, notifier);
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
    testWidgets('watch should throw FlutterError when not found',
        (tester) async {
      await tester.pumpWidget(
        Builder(builder: (context) {
          // Use isA<FlutterError> instead of throwsException
          expect(
            () => context.watch<TestNotifier>(),
            throwsA(isA<FlutterError>()),
          );
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
      final notifier = TestNotifier();

      await tester.pumpWidget(
        MinProvider(
          create: () => notifier,
          child: Builder(builder: (context) {
            final found = context.read<TestNotifier>();
            expect(found, notifier);
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
      final notifier = TestNotifier();

      await tester.pumpWidget(
        MinMultiProvider(
          create: [() => notifier],
          child: Builder(builder: (context) {
            final found = context.read<TestNotifier>();
            expect(found, notifier);
            return Container();
          }),
        ),
      );
    });

    /// {@template min_provider_extensions_test.tagged_lookup_error}
    /// **Test Target:** Extension tagged lookup error
    ///
    /// **Objective:** Verifies that when searching for a tagged notifier, if the
    /// provider of type [T] exists in the tree but the specific [tag] does not
    /// match any registered instance, the extension throws a [FlutterError].
    /// {@endtemplate}
    testWidgets(
      'Should throw FlutterError if specific tag lookup fails in extension',
      (tester) async {
        await tester.pumpWidget(
          MinMultiProvider(
            create: [
              // Registra um notifier, mas SEM a tag solicitada
              () => TestNotifier(),
            ],
            child: Builder(builder: (context) {
              // A extensão encontrará o MinMultiProvider, mas a busca pela tag falhará
              // disparando o throw FlutterError na linha 46
              expect(
                () => context.read<TestNotifier>(tag: 'invalid_tag'),
                throwsA(isA<FlutterError>()),
              );
              return Container();
            }),
          ),
        );
      },
    );

    /// {@template min_provider_extensions_test.read_not_found}
    /// **Test Target:** `read` Not Found Error
    ///
    /// **Objective:** Assures that attempting to [read] a notifier when no
    /// provider is present in the tree throws an [Exception].
    /// {@endtemplate}
    testWidgets('read should throw FlutterError when not found',
        (tester) async {
      await tester.pumpWidget(
        Builder(builder: (context) {
          // Use isA<FlutterError> to catch the error thrown by your extension
          expect(
            () => context.read<TestNotifier>(),
            throwsA(isA<FlutterError>()),
          );
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
        'Read should throw FlutterError if type is missing in MultiProvider',
        (tester) async {
      await tester.pumpWidget(
        MinMultiProvider(
          create: [() => RegisteredNotifier()],
          child: Builder(builder: (context) {
            expect(
              () => context.read<MissingNotifier>(),
              throwsA(isA<FlutterError>()),
            );
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
      'Watch should throw FlutterError if type is missing in MultiProvider',
      (tester) async {
        await tester.pumpWidget(
          MinMultiProvider(
            create: [() => RegisteredNotifier()],
            child: Builder(builder: (context) {
              expect(
                () => context.watch<MissingNotifier>(),
                throwsA(isA<FlutterError>()),
              );
              return Container();
            }),
          ),
        );
      },
    );
    group('ProviderExtension Tests  MinMultiProvider with Tags', () {
      /// {@template min_provider_extensions_test.watch_tagged}
      /// **Test Target:** `watch` with Tag
      ///
      /// **Objective:** Verifies that [watch] retrieves the correct instance
      /// when a specific tag is provided.
      /// {@endtemplate}
      testWidgets('watch should retrieve tagged instance', (tester) async {
        final notifier = TestNotifier();

        await tester.pumpWidget(
          MinMultiProvider(
            create: [
              () => notifier.tag('admin'),
            ],
            child: Builder(builder: (context) {
              final found = context.watch<TestNotifier>(tag: 'admin');
              expect(found, notifier);
              return Container();
            }),
          ),
        );
      });

      /// {@template min_provider_extensions_test.read_tagged}
      /// **Test Target:** `read` with Tag
      ///
      /// **Objective:** Verifies that [read] retrieves the correct instance
      /// using a tag lookup.
      /// {@endtemplate}
      testWidgets('read should retrieve tagged instance', (tester) async {
        final notifier = TestNotifier();

        await tester.pumpWidget(
          MinMultiProvider(
            create: [
              () => notifier.tag('user'),
            ],
            child: Builder(builder: (context) {
              final found = context.read<TestNotifier>(tag: 'user');
              expect(found, notifier);
              return Container();
            }),
          ),
        );
      });

      /// {@template min_provider_extensions_test.wrong_tag_error}
      /// **Test Target:** Wrong Tag Error
      ///
      /// **Objective:** Verifies that requesting a notifier with a tag that
      /// does not exist (but the type does) throws a [FlutterError].
      /// {@endtemplate}
      testWidgets('should throw FlutterError when tag is incorrect',
          (tester) async {
        await tester.pumpWidget(
          MinMultiProvider(
            create: [
              () => TestNotifier().tag('correct'),
            ],
            child: Builder(builder: (context) {
              expect(
                () => context.read<TestNotifier>(tag: 'wrong'),
                throwsA(isA<FlutterError>()),
              );
              return Container();
            }),
          ),
        );
      });

      /// {@template min_provider_extensions_test.untagged_requested_tagged_exists}
      /// **Test Target:** Untagged Request for Tagged Provider
      ///
      /// **Objective:** Verifies that requesting an untagged instance when
      /// only a tagged one exists throws a [FlutterError].
      /// {@endtemplate}
      testWidgets(
          'should throw FlutterError when requesting untagged but only tagged exists',
          (tester) async {
        await tester.pumpWidget(
          MinMultiProvider(
            create: [
              () => TestNotifier().tag('admin'),
            ],
            child: Builder(builder: (context) {
              expect(
                () => context.read<TestNotifier>(),
                throwsA(isA<FlutterError>()),
              );
              return Container();
            }),
          ),
        );
      });
    });
    group('MinProvider Tests with Tags', () {
      /// {@template min_provider_test.watch_tagged}
      /// **Test Target:** `MinProvider.watch` with Tag
      ///
      /// **Objective:** Verifies that [watch] correctly navigates the inherited
      /// tree to find the specifically tagged provider.
      /// {@endtemplate}
      testWidgets('watch should retrieve tagged MinProvider instance',
          (tester) async {
        final notifier = TestNotifier();

        await tester.pumpWidget(
          MinProvider(
            create: () => notifier,
            tag: 'admin', // Requires adding tag parameter to MinProvider
            child: Builder(builder: (context) {
              final found =
                  MinProvider.watch<TestNotifier>(context, tag: 'admin');
              expect(found, notifier);
              return Container();
            }),
          ),
        );
      });

      /// {@template min_provider_test.read_tagged}
      /// **Test Target:** `MinProvider.read` with Tag
      ///
      /// **Objective:** Verifies that [read] correctly locates the tagged provider.
      /// {@endtemplate}
      testWidgets('read should retrieve tagged MinProvider instance',
          (tester) async {
        final notifier = TestNotifier();

        await tester.pumpWidget(
          MinProvider(
            create: () => notifier,
            tag: 'user', // Requires adding tag parameter
            child: Builder(builder: (context) {
              final found =
                  MinProvider.read<TestNotifier>(context, tag: 'user');
              expect(found, notifier);
              return Container();
            }),
          ),
        );
      });

      /// {@template min_provider_test.wrong_tag_error}
      /// **Test Target:** MinProvider Wrong Tag Error
      ///
      /// **Objective:** Verifies that looking for a non-existent tag
      /// throws a [FlutterError].
      /// {@endtemplate}
      testWidgets('MinProvider should throw FlutterError when tag is incorrect',
          (tester) async {
        await tester.pumpWidget(
          MinProvider(
            create: () => TestNotifier(),
            tag: 'correct',
            child: Builder(builder: (context) {
              expect(
                () => MinProvider.read<TestNotifier>(context, tag: 'wrong'),
                throwsA(isA<FlutterError>()),
              );
              return Container();
            }),
          ),
        );
      });
    });
  });
}
