/// # UI Rebuild Isolation and Scope Precision Benchmark
///
/// This benchmark measures the ability of each state management solution to achieve
/// **Perfect Rebuild Isolation** under a heavy UI rendering stress loop.
///
/// ## What this test simulates:
/// A high-stress interactive flow where a reactive data field is updated 1,000 times
/// back-to-back. The targeted UI component must react and rebuild exactly once per
/// mutation frame, without over-rendering (wasteful rebuilds) and without under-rendering
/// (skipping frames or lagging updates).
///
/// ## Reading the Metrics:
/// * **Target Metric:** Exactly **1001 Rebuilds** ($1 \text{ initial build} + 1000 \text{ state updates}$).
/// * **Greater than 1001 (BAD):** Indicates ghost rebuilds, lack of precision, or leaky state scopes, wasting CPU cycles on unnecessary visual redraws.
/// * **Less than 1001 (BAD for synchronous rendering):** Indicates the state manager skipped frames or suffered from lag/throttling, dropping asynchronous updates on high-frequency changes.
/// * **Exactly 1001 (PERFECT):** Indicates ideal atomic UI isolation. The rendering thread is perfectly synchronized with the data engine.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minimals_state_manager/minimals_state_manager.dart';

// --- 1. STATE MANAGERS INITIALIZATION ---

// Minimals
class MyMinNotifier extends MinNotifier {
  int counter = 0;
  String unrelatedData = "Hello";

  void increment() {
    counter++;
    notifyListeners();
  }
}

// BLoC
class MyBlocState {
  final int counter;
  final String unrelatedData;
  MyBlocState(this.counter, this.unrelatedData);
}

class MyCubit extends Cubit<MyBlocState> {
  MyCubit() : super(MyBlocState(0, "Hello"));
  void increment() => emit(MyBlocState(state.counter + 1, state.unrelatedData));
}

// Riverpod
class RiverpodState {
  final int counter;
  final String unrelatedData;
  RiverpodState(this.counter, this.unrelatedData);
}

class MyRiverpodNotifier extends Notifier<RiverpodState> {
  @override
  RiverpodState build() => RiverpodState(0, "Hello");
  void increment() =>
      state = RiverpodState(state.counter + 1, state.unrelatedData);
}

final myRiverpodProvider =
    NotifierProvider<MyRiverpodNotifier, RiverpodState>(MyRiverpodNotifier.new);

// --- 2. BENCHMARK WIDGET TESTS ---

void main() {
  int minimalsBuildCount = 0;
  int blocBuildCount = 0;
  int riverpodBuildCount = 0;
  int nativeSetStateBuildCount = 0;

  setUp(() {
    minimalsBuildCount = 0;
    blocBuildCount = 0;
    riverpodBuildCount = 0;
    nativeSetStateBuildCount = 0;
  });

  group('UI Rebuild Isolation Benchmarks', () {
    debugPrint('\n=== STARTING UI REBUILD ISOLATION BENCHMARKS ===');
    debugPrint(
        '>> Checking frame precision (Ideal target is exactly 1001 rebuilds):');

    // ==================== MINIMALS SELECTOR ($) TEST ====================
    testWidgets('Minimals selector `\$` rebuild isolation test',
        (WidgetTester tester) async {
      final controller = MyMinNotifier();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: $<MyMinNotifier, int>(
              notifier: controller,
              selector: (ctl) => ctl.counter,
              builder: (context, counter) {
                minimalsBuildCount++;
                return Text('Counter: $counter');
              },
            ),
          ),
        ),
      );

      for (int i = 0; i < 1000; i++) {
        controller.increment();
        await tester.pump();
      }

      debugPrint(
          '- Minimals Selector (\$) Total Rebuilds: $minimalsBuildCount');
      expect(minimalsBuildCount, equals(1001));
    });

    // ==================== BLOC BUILDER TEST ====================
    testWidgets('BLoC BlocBuilder rebuild test', (WidgetTester tester) async {
      final cubit = MyCubit();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<MyCubit>(
              create: (_) => cubit,
              child: BlocBuilder<MyCubit, MyBlocState>(
                buildWhen: (previous, current) =>
                    previous.counter != current.counter,
                builder: (context, state) {
                  blocBuildCount++;
                  return Text('Counter: ${state.counter}');
                },
              ),
            ),
          ),
        ),
      );

      for (int i = 0; i < 1000; i++) {
        cubit.increment();
        await tester.pump(Duration.zero);
      }

      debugPrint('- BLoC BlocBuilder Total Rebuilds: $blocBuildCount ');
      expect(blocBuildCount, equals(1001));
    });

    // ==================== FLUTTER NATIVE (setState) TEST ====================
    testWidgets('Flutter Native setState rebuild test',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (BuildContext context, StateSetter setStateCustom) {
                nativeSetStateBuildCount++;

                if (nativeSetStateBuildCount <= 1000) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setStateCustom(() {});
                  });
                }

                return Text('Rebuild Count: $nativeSetStateBuildCount');
              },
            ),
          ),
        ),
      );

      for (int i = 0; i < 1000; i++) {
        await tester.pump();
      }

      debugPrint(
          '- Flutter Native setState Total Rebuilds: $nativeSetStateBuildCount');
      expect(nativeSetStateBuildCount, equals(1001));
    });

    // ==================== RIVERPOD CONSUMER TEST ====================
    testWidgets('Riverpod Consumer/select rebuild test',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  final counter =
                      ref.watch(myRiverpodProvider.select((s) => s.counter));
                  riverpodBuildCount++;
                  return Text('Counter: $counter');
                },
              ),
            ),
          ),
        ),
      );

      for (int i = 0; i < 1000; i++) {
        final container =
            ProviderScope.containerOf(tester.element(find.byType(Scaffold)));
        container.read(myRiverpodProvider.notifier).increment();
        await tester.pump();
      }

      debugPrint('- Riverpod Consumer Total Rebuilds: $riverpodBuildCount ');
      expect(riverpodBuildCount, equals(1001));

      debugPrint('\n=== BENCHMARK EXECUTION COMPLETED ===\n');
    });
  });
}
