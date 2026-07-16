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

void main() {
  group('MinMultiProvider Tests', () {
    testWidgets('Should inject multiple controllers and support static access',
        (tester) async {
      final n1 = MultiNotifier();
      final n2 = CartNotifier();
      final n3 = SettingsNotifier();

      await tester.pumpWidget(
        MinMultiProvider(
          create: [() => n1, () => n2, () => n3],
          child: Builder(builder: (context) {
            // Agora cada busca é específica e inequívoca
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

    testWidgets('Should throw error when provider missing', (tester) async {
      await tester.pumpWidget(Builder(builder: (context) {
        expect(() => MinMultiProvider.read<MultiNotifier>(context),
            throwsFlutterError);
        expect(() => MinMultiProvider.watch<MultiNotifier>(context),
            throwsFlutterError);
        return Container();
      }));
    });

    testWidgets('Should throw error when type not found in MultiProvider',
        (tester) async {
      await tester.pumpWidget(
        MinMultiProvider(
          create: [() => ChangeNotifier()],
          child: Builder(builder: (context) {
            expect(() => MinMultiProvider.read<MultiNotifier>(context),
                throwsFlutterError);
            return Container();
          }),
        ),
      );
    });
  });
}
