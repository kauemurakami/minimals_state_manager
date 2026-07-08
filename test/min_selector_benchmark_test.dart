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
  // Counters to track the exact number of build executions
  int minimalsBuildCount = 0;
  int blocBuildCount = 0;
  int riverpodBuildCount = 0;

  setUp(() {
    minimalsBuildCount = 0;
    blocBuildCount = 0;
    riverpodBuildCount = 0;
  });

  group('UI Rebuild Isolation Benchmarks', () {
    // ==================== MINIMALS SELECOR ($) TEST ====================
    testWidgets('Minimals selector `\$` rebuild isolation test',
        (WidgetTester tester) async {
      final controller = MyMinNotifier();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: $<MyMinNotifier, int>(
              notifier: controller,
              selector: (ctl) =>
                  ctl.counter, // Selecting only the counter integer
              builder: (context, counter) {
                minimalsBuildCount++; // Tracking build trigger
                return Text('Counter: $counter');
              },
            ),
          ),
        ),
      );

      // Simulate 1000 fast state updates
      for (int i = 0; i < 1000; i++) {
        controller.increment();
        await tester.pump(); // Triggers microtask layout pipeline
      }

      print('-> Minimals Selector (\$) Total Rebuilds: $minimalsBuildCount');
      expect(
          minimalsBuildCount, equals(1001)); // 1 initial build + 1000 updates
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
        // Usar pump(Duration.zero) força a liberação imediata da fila de microtasks do BLoC
        await tester.pump(Duration.zero);
      }

      print('-> BLoC BlocBuilder Total Rebuilds: $blocBuildCount');
      expect(
          blocBuildCount, equals(1001)); // Now it will correctly register 1001
    });

    // ==================== FLUTTER NATIVE (setState) TEST ====================
    int nativeSetStateBuildCount = 0;

    testWidgets('Flutter Native setState rebuild test',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (BuildContext context, StateSetter setStateCustom) {
                nativeSetStateBuildCount++;

                // We simulate an interactive action that triggers setState inside the tree
                // In a real app, this would be a button tap or internal state mutation
                if (nativeSetStateBuildCount <= 1000) {
                  // Schedules the next frame update immediately to simulate 1000 sequential builds
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

      // Pump the loop to process the scheduled post-frame callbacks up to 1000 iterations
      for (int i = 0; i < 1000; i++) {
        await tester.pump();
      }

      print(
          '-> Flutter Native setState Total Rebuilds: $nativeSetStateBuildCount');
      expect(nativeSetStateBuildCount,
          equals(1001)); // 1 initial build + 1000 state mutations
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
                  // Selecting only the counter property from the global state object
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

      print('-> Riverpod Consumer Total Rebuilds: $riverpodBuildCount');
      expect(riverpodBuildCount, equals(1001));
    });
  });
}
