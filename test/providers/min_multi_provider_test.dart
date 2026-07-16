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
    /// {@template min_multi_provider_test.injection}
    /// **Test Target:** `MinMultiProvider` Injection
    ///
    /// **Objective:** Verifies that multiple notifiers are correctly injected
    /// and accessible via static [read] calls.
    /// {@endtemplate}
    testWidgets('Should inject multiple notifier and support static access',
        (tester) async {
      final n1 = MultiNotifier();
      final n2 = CartNotifier();
      final n3 = SettingsNotifier();

      await tester.pumpWidget(
        MinMultiProvider(
          create: [() => n1, () => n2, () => n3],
          child: Builder(builder: (context) {
            final read1 = MinMultiProvider.read<MultiNotifier>(context);
            final read2 = MinMultiProvider.read<CartNotifier>(context);
            final read3 = MinMultiProvider.read<SettingsNotifier>(context);

            expect(read1, n1);
            expect(read2, n2);
            expect(read3, n3);
            return Container();
          }),
        ),
      );

      expect(n1.onInitCalled, isTrue);
    });

    /// {@template min_multi_provider_test.watch}
    /// **Test Target:** `MinMultiProvider.watch`
    ///
    /// **Objective:** Verifies that the provider correctly exposes notifiers
    /// through the watch method.
    /// {@endtemplate}
    testWidgets('Watch should work for MultiProvider', (tester) async {
      final n1 = MultiNotifier();

      await tester.pumpWidget(
        MinMultiProvider(
          create: [() => n1],
          child: Builder(builder: (context) {
            final watch = MinMultiProvider.watch<MultiNotifier>(context);
            expect(watch, n1);
            return Container();
          }),
        ),
      );
    });

    /// {@template min_multi_provider_test.missing_provider}
    /// **Test Target:** Missing Provider Error
    ///
    /// **Objective:** Assures that calling read/watch without an ancestor
    /// [MinMultiProvider] throws a [FlutterError].
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

    /// {@template min_multi_provider_test.read_missing_type}
    /// **Test Target:** Missing Type Error (Read)
    ///
    /// **Objective:** Verifies that requesting a non-existent type via [read]
    /// throws a clear [FlutterError].
    /// {@endtemplate}
    testWidgets('Read should throw FlutterError if notifier type is missing',
        (tester) async {
      await tester.pumpWidget(
        MinMultiProvider(
          create: [() => RegisteredNotifier()],
          child: Builder(builder: (context) {
            expect(
              () => MinMultiProvider.read<MissingNotifier>(context),
              throwsA(isA<FlutterError>()),
            );
            return Container();
          }),
        ),
      );
    });

    /// {@template min_multi_provider_test.watch_missing_type}
    /// **Test Target:** Missing Type Error (Watch)
    ///
    /// **Objective:** Verifies that requesting a non-existent type via [watch]
    /// throws a clear [FlutterError].
    /// {@endtemplate}
    testWidgets('Watch should throw FlutterError if notifier type is missing',
        (tester) async {
      await tester.pumpWidget(
        MinMultiProvider(
          create: [() => RegisteredNotifier()],
          child: Builder(builder: (context) {
            expect(
              () => MinMultiProvider.watch<MissingNotifier>(context),
              throwsA(isA<FlutterError>()),
            );
            return Container();
          }),
        ),
      );
    });
  });
}
