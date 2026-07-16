import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimals_state_manager/minimals_state_manager.dart';

/// Dummy class for testing [MinMultiProvider] lifecycle and state.
class MultiNotifier extends MinNotifier {
  bool onInitCalled = false;
  @override
  void onInit() {
    onInitCalled = true;
  }
}

class CartNotifier extends ChangeNotifier {}

class SettingsNotifier extends ChangeNotifier {}

class RegisteredNotifier extends MinNotifier {}

class MissingNotifier extends ChangeNotifier {}

void main() {
  group('MinMultiProvider Tests', () {
    // --- SUCCESS SCENARIOS ---

    /// {@template min_multi_provider_test.injection}
    /// **Test Target:** `MinMultiProvider` Injection
    /// **Objective:** Verifies that multiple notifiers are correctly injected and
    /// accessible via static [read] calls and that lifecycle methods are triggered.
    /// {@endtemplate}
    testWidgets('Should inject multiple notifiers and support static access',
        (tester) async {
      final n1 = MultiNotifier();
      final n2 = CartNotifier();
      final n3 = SettingsNotifier();

      await tester.pumpWidget(
        MinMultiProvider(
          create: [() => n1, () => n2, () => n3],
          child: Builder(builder: (context) {
            expect(MinMultiProvider.read<MultiNotifier>(context), n1);
            expect(MinMultiProvider.read<CartNotifier>(context), n2);
            expect(MinMultiProvider.read<SettingsNotifier>(context), n3);
            return Container();
          }),
        ),
      );
      expect(n1.onInitCalled, isTrue);
    });

    /// {@template min_multi_provider_test.watch}
    /// **Test Target:** `MinMultiProvider.watch`
    /// **Objective:** Verifies that the provider correctly exposes notifiers through the watch method.
    /// {@endtemplate}
    testWidgets('Watch should work for MultiProvider', (tester) async {
      final n1 = MultiNotifier();
      await tester.pumpWidget(
        MinMultiProvider(
          create: [() => n1],
          child: Builder(builder: (context) {
            expect(MinMultiProvider.watch<MultiNotifier>(context), n1);
            return Container();
          }),
        ),
      );
    });

    /// {@template min_multi_provider_test.untagged_factory}
    /// **Test Target:** Untagged factory resolution
    /// **Objective:** Verifies that a standard factory function is registered properly.
    /// {@endtemplate}
    testWidgets('Should process untagged factory function correctly',
        (tester) async {
      final notifier = CartNotifier();
      await tester.pumpWidget(
        MinMultiProvider(
          create: [() => notifier],
          child: Builder(builder: (context) {
            expect(context.read<CartNotifier>(), notifier);
            return Container();
          }),
        ),
      );
    });

    /// {@template min_multi_provider_test.factory_function_resolution}
    /// **Test Target:** Factory function resolution (Covers lines 99-100).
    /// **Objective:** Verifies that a registered factory function is correctly invoked
    /// as a T Function() to resolve the notifier.
    /// {@endtemplate}
    testWidgets('Should execute factory function to resolve notifier',
        (tester) async {
      await tester.pumpWidget(
        MinMultiProvider(
          create: [() => CartNotifier()],
          child: Builder(builder: (context) {
            expect(MinMultiProvider.read<CartNotifier>(context),
                isA<CartNotifier>());
            return Container();
          }),
        ),
      );
    });

    /// {@template min_multi_provider_test.type_mismatch_error}
    /// **Test Target:** Type mismatch error (Covers lines 102-104).
    /// **Objective:** Forces the resolution logic into the final 'else' block
    /// by registering one type but attempting to read another incompatible type.
    /// {@endtemplate}
    testWidgets('Should throw error when resolved type does not match T',
        (tester) async {
      await tester.pumpWidget(
        MinMultiProvider(
          create: [() => SettingsNotifier()],
          child: Builder(builder: (context) {
            expect(
              () => MinMultiProvider.read<CartNotifier>(context),
              throwsA(isA<FlutterError>()),
            );
            return Container();
          }),
        ),
      );
    });

    /// {@template min_multi_provider_test.plain_change_notifier_factory}
    /// **Test Target:** Plain ChangeNotifier factory resolution (Covers lines 138-141).
    /// **Objective:** Ensures that if a generic ChangeNotifier factory is returned,
    /// the provider correctly resolves and casts it.
    /// {@endtemplate}
    testWidgets('Should handle plain ChangeNotifier factory resolution',
        (tester) async {
      await tester.pumpWidget(
        MinMultiProvider(
          create: [() => CartNotifier()],
          child: Builder(builder: (context) {
            final notifier = MinMultiProvider.read<CartNotifier>(context);
            expect(notifier, isA<CartNotifier>());
            return Container();
          }),
        ),
      );
    });

    /// {@template min_multi_provider_test.tagged_lookup_success}
    /// **Test Target:** Tagged lookup success
    /// **Objective:** Verifies that requesting an existing tag returns the correct notifier.
    /// {@endtemplate}
    testWidgets('Read/Watch should return correct notifier when tag exists',
        (tester) async {
      final adminCart = CartNotifier();
      final userCart = CartNotifier();

      await tester.pumpWidget(
        MinMultiProvider(
          create: [
            () => adminCart.tag('admin'),
            () => userCart.tag('user'),
          ],
          child: Builder(builder: (context) {
            expect(MinMultiProvider.read<CartNotifier>(context, tag: 'admin'),
                adminCart);
            expect(MinMultiProvider.read<CartNotifier>(context, tag: 'user'),
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
      final defaultNotifier = CartNotifier();

      await tester.pumpWidget(
        MinMultiProvider(
          create: [() => defaultNotifier],
          child: Builder(builder: (context) {
            expect(
                MinMultiProvider.read<CartNotifier>(context), defaultNotifier);
            return Container();
          }),
        ),
      );
    });

    /// {@template min_multi_provider_test.factory_resolution}
    /// **Test Target:** Factory function resolution.
    /// **Objective:** Verifies that registering via a factory function
    /// (e.g., () => T) correctly resolves the notifier (Covers lines 99-100).
    /// {@endtemplate}
    testWidgets('Should resolve factory function correctly', (tester) async {
      final cart = CartNotifier();
      await tester.pumpWidget(
        MinMultiProvider(
          create: [() => cart],
          child: Builder(builder: (context) {
            final resolved = MinMultiProvider.read<CartNotifier>(context);
            expect(resolved, cart);
            return Container();
          }),
        ),
      );
    });

    // --- ERROR HANDLING SCENARIOS ---

    /// {@template min_multi_provider_test.tagged_missing_error}
    /// **Test Target:** Tagged lookup error handling.
    /// **Objective:** Verifies that requesting a tag that was not registered
    /// throws the expected [FlutterError] (Covers lines 80-81).
    /// {@endtemplate}
    testWidgets(
        'Should throw FlutterError when searching for a non-existent tag',
        (tester) async {
      await tester.pumpWidget(
        MinMultiProvider(
          create: [() => CartNotifier().tag('other')],
          child: Builder(builder: (context) {
            expect(
              () => MinMultiProvider.read<CartNotifier>(context, tag: 'admin'),
              throwsA(isA<FlutterError>()),
            );
            return Container();
          }),
        ),
      );
    });

    /// {@template min_multi_provider_test.invalid_type_error}
    /// **Test Target:** Invalid type resolution.
    /// **Objective:** Verifies that if an entry is found but is neither T
    /// nor a valid factory, it throws a descriptive error (Covers lines 102-104).
    /// {@endtemplate}
    testWidgets('Should throw error when found notifier type does not match T',
        (tester) async {
      await tester.pumpWidget(
        MinMultiProvider(
          create: [() => SettingsNotifier()],
          child: Builder(builder: (context) {
            expect(
              () => MinMultiProvider.read<CartNotifier>(context),
              throwsA(isA<FlutterError>()),
            );
            return Container();
          }),
        ),
      );
    });

    /// {@template min_multi_provider_test.generic_factory_resolution}
    /// **Test Target:** Generic factory resolution.
    /// **Objective:** Verifies resolution when the result is a plain
    /// ChangeNotifier factory function (Covers lines 138-141).
    /// {@endtemplate}
    testWidgets('Should handle plain ChangeNotifier factory resolution',
        (tester) async {
      await tester.pumpWidget(
        MinMultiProvider(
          create: [() => CartNotifier()],
          child: Builder(builder: (context) {
            expect(MinMultiProvider.read<CartNotifier>(context),
                isA<CartNotifier>());
            return Container();
          }),
        ),
      );
    });

    /// {@template min_multi_provider_test.empty_list_validation}
    /// **Test Target:** Empty list validation
    /// **Objective:** Ensures [MinMultiProvider] throws if 'create' is empty.
    /// {@endtemplate}
    test('Should throw FlutterError if create list is empty', () {
      expect(
        () => MinMultiProvider(create: [], child: Container()),
        throwsA(isA<FlutterError>()),
      );
    });

    /// {@template min_multi_provider_test.missing_provider}
    /// **Test Target:** Missing Provider Error
    /// **Objective:** Assures that calling read/watch without an ancestor throws.
    /// {@endtemplate}
    testWidgets('Should throw error when provider missing', (tester) async {
      await tester.pumpWidget(Builder(builder: (context) {
        expect(() => MinMultiProvider.read<MultiNotifier>(context),
            throwsFlutterError);
        expect(() => MinMultiProvider.watch<MultiNotifier>(context),
            throwsFlutterError);
        return Container();
      }));
    });

    /// {@template min_multi_provider_test.missing_type}
    /// **Test Target:** Missing Type Error
    /// **Objective:** Verifies that requesting a non-existent type throws.
    /// {@endtemplate}
    testWidgets(
        'Read/Watch should throw FlutterError if notifier type is missing',
        (tester) async {
      await tester.pumpWidget(
        MinMultiProvider(
          create: [() => RegisteredNotifier()],
          child: Builder(builder: (context) {
            expect(() => MinMultiProvider.read<MissingNotifier>(context),
                throwsA(isA<FlutterError>()));
            expect(() => MinMultiProvider.watch<MissingNotifier>(context),
                throwsA(isA<FlutterError>()));
            return Container();
          }),
        ),
      );
    });

    /// {@template min_multi_provider_test.tagged_lookup_error}
    /// **Test Target:** Tagged lookup error
    /// **Objective:** Verifies that requesting a tag that does not exist throws.
    /// {@endtemplate}
    testWidgets('Read/Watch should throw FlutterError if tag does not exist',
        (tester) async {
      await tester.pumpWidget(
        MinMultiProvider(
          create: [() => CartNotifier().tag('admin')],
          child: Builder(builder: (context) {
            expect(() => context.read<CartNotifier>(tag: 'user'),
                throwsA(isA<FlutterError>()));
            expect(() => context.watch<CartNotifier>(tag: 'user'),
                throwsA(isA<FlutterError>()));
            return Container();
          }),
        ),
      );
    });
  });
}
