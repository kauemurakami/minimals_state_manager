import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimals_state_manager/minimals_state_manager.dart';

/// Dummy class to act as our state manager for testing purposes.
class TestController extends ChangeNotifier {
  int value = 0;
  void increment() {
    value++;
    notifyListeners();
  }
}

void main() {
  group('ProviderExtension Tests', () {
    testWidgets('watch should retrieve from MinInherited', (tester) async {
      final controller = TestController();

      await tester.pumpWidget(
        MinProvider(
          create: () => controller,
          child: Builder(builder: (context) {
            final found = context.watch<TestController>();
            expect(found, controller);
            return Container();
          }),
        ),
      );
    });

    testWidgets('watch should retrieve from MinMultiProvider', (tester) async {
      final controller = TestController();

      await tester.pumpWidget(
        MinMultiProvider(
          create: [() => controller],
          child: Builder(builder: (context) {
            final found = context.watch<TestController>();
            expect(found, controller);
            return Container();
          }),
        ),
      );
    });

    testWidgets('watch should throw exception when not found', (tester) async {
      await tester.pumpWidget(
        Builder(builder: (context) {
          expect(() => context.watch<TestController>(), throwsException);
          return Container();
        }),
      );
    });

    testWidgets('read should retrieve from MinInherited', (tester) async {
      final controller = TestController();

      await tester.pumpWidget(
        MinProvider(
          create: () => controller,
          child: Builder(builder: (context) {
            final found = context.read<TestController>();
            expect(found, controller);
            return Container();
          }),
        ),
      );
    });

    testWidgets('read should retrieve from MinMultiProvider', (tester) async {
      final controller = TestController();

      await tester.pumpWidget(
        MinMultiProvider(
          create: [() => controller],
          child: Builder(builder: (context) {
            final found = context.read<TestController>();
            expect(found, controller);
            return Container();
          }),
        ),
      );
    });

    testWidgets('read should throw exception when not found', (tester) async {
      await tester.pumpWidget(
        Builder(builder: (context) {
          expect(() => context.read<TestController>(), throwsException);
          return Container();
        }),
      );
    });

    testWidgets('read should throw exception when not found in MultiProvider',
        (tester) async {
      // Testing the orElse branch of firstWhere in MultiProvider
      await tester.pumpWidget(
        MinMultiProvider(
          create: [() => ChangeNotifier()],
          child: Builder(builder: (context) {
            expect(() => context.read<TestController>(), throwsException);
            return Container();
          }),
        ),
      );
    });
  });
}
