/// # State Engine Notification and Dispatch Microbenchmark
///
/// This microbenchmark isolates and measures the pure execution overhead of triggering a single
/// state update and propagating it to a registered listener across different state management systems.
///
/// ## What this test simulates:
/// The absolute atomic performance of an isolated state container. Unlike the mutation stress test
/// which loops mutations intensely inside a single frame run, this test measures the continuous
/// execution efficiency of the notification dispatch pipeline itself (`notifyListeners`, `emit`, or `state =`)
/// under the `benchmark_harness` iteration engine.
///
/// ## Reading the Metrics:
/// * **Target Metric:** Execution runtime in microseconds (`us`) and milliseconds (`ms`).
/// * **Lower Values (BETTER):** Indicates a lean execution path. The engine can receive a state change
///   and immediately flag or alert UI subscribers with close-to-zero CPU cycles, ensuring fluid interface
///   re-rendering.
/// * **Higher Values (WORSE):** Indicates substantial architecture tax per single update event
///   (such as stream microtask scheduling, equality verification passes, or state tree traversals).
import 'package:all_observer/all_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riverpod/riverpod.dart';
import 'package:minimals_state_manager/minimals_state_manager.dart';

// --- 1. STATE NOTIFIERS ---

class MinimalsCounterNotifier extends MinNotifier {
  int count = 0;

  void increment() {
    count++;
    notifyListeners();
  }
}

class NativeCounterNotifier extends ChangeNotifier {
  int count = 0;

  void increment() {
    count++;
    notifyListeners();
  }
}

class BlocCounterCubit extends Cubit<int> {
  BlocCounterCubit() : super(0);
  void increment() => emit(state + 1);
}

class RiverpodCounter extends Notifier<int> {
  @override
  int build() => 0;
  void increment() => state = state + 1;
}

final riverpodProvider =
    NotifierProvider<RiverpodCounter, int>(RiverpodCounter.new);

// --- 2. HARNESSES BENCHMARK ---

class MinimalsHarness extends BenchmarkBase {
  late MinimalsCounterNotifier controller;
  MinimalsHarness() : super('Minimals (MinNotifier)');

  @override
  void setup() {
    controller = MinimalsCounterNotifier();
    controller.addListener(() {});
  }

  @override
  void run() => controller.increment();
}

class NativeHarness extends BenchmarkBase {
  late NativeCounterNotifier notifier;
  NativeHarness() : super('Flutter Native (ChangeNotifier)');

  @override
  void setup() {
    notifier = NativeCounterNotifier();
    notifier.addListener(() {});
  }

  @override
  void run() => notifier.increment();
}

class BlocHarness extends BenchmarkBase {
  late BlocCounterCubit cubit;
  BlocHarness() : super('BLoC (Cubit)');

  @override
  void setup() {
    cubit = BlocCounterCubit();
    cubit.stream.listen((_) {});
  }

  @override
  void run() => cubit.increment();
}

class RiverpodHarness extends BenchmarkBase {
  late ProviderContainer container;
  RiverpodHarness() : super('Riverpod (Notifier)');

  @override
  void setup() {
    container = ProviderContainer();
    container.listen(riverpodProvider, (_, __) {});
  }

  @override
  void run() => container.read(riverpodProvider.notifier).increment();
}

class AllObserverHarness extends BenchmarkBase {
  late Observable<int> counter;
  late ObservableSubscription subscription;

  AllObserverHarness() : super('All Observer (Observable)');

  @override
  void setup() {
    counter = 0.obs;
    subscription = counter.listen((_) {});
  }

  @override
  void run() => counter.value++;

  @override
  void teardown() {
    subscription.cancel();
  }
}

// --- 3. EXECUTION PATH WITH AUTO-CONVERSION ---
void main() {
  test('Execute Microbenchmarks of state', () {
    debugPrint('\n=== INIT BENCHMARK STATE ENGINES ===');
    debugPrint(
        '>> Tracking execution runtime per single atomic notification cycle (Lower is Better):');

    final minimalsUs = MinimalsHarness().measure();
    final nativeUs = NativeHarness().measure();
    final blocUs = BlocHarness().measure();
    final riverpodUs = RiverpodHarness().measure();
    final allObserver = AllObserverHarness().measure();

    void printMetric(String name, double us) {
      double ms = us / 1000.0;
      debugPrint(
          '$name: ${us.toStringAsFixed(5)} us / ${ms.toStringAsFixed(5)} ms');
    }

    printMetric('Minimals (MinNotifier)                ', minimalsUs);
    printMetric('Flutter Native (ChangeNotifier)       ', nativeUs);
    printMetric('BLoC (Cubit)                          ', blocUs);
    printMetric('Riverpod (Notifier)                   ', riverpodUs);
    printMetric('All Observer (Observable)             ', allObserver);

    debugPrint('\n================================================\n');
  });
}
