// # Multi-Listener Scalability Benchmark
///
/// ## Purpose
/// This benchmark evaluates and compares the scalability and processing efficiency of state mutation propagation
/// across three different state management solutions: `minimals_state_manager` (`MinNotifier`), Flutter's native `ValueNotifier`,
/// and `flutter_bloc` (`Cubit` streams). It simulates a high-density subscriber topology containing 1,000 active concurrent listeners.
///
/// ## What it Measures
/// * **Notification Dispatch Pipeline:** The absolute time taken to loop through, trigger, and execute callback functions for all registered subscribers.
/// * **Algorithmic Efficiency:** The impact of O(N) operations when a single state mutation ripples through a high volume of UI components or data consumers simultaneously.
///
/// ## Metric Rule: Lower is Better
/// * **Lower values (Faster):** Indicates a highly optimized notification dispatch engine. Faster execution runtime proves
///   the library can maintain stable, linear throughput without wasting CPU cycles. This guarantees that updating complex
///   or high-density UI layouts will not result in frame drops (jank) or micro-stutters.
/// * **Higher values (Slower):** Exposes internal overhead within the subscriber synchronization mechanism. Slower runtimes mean
///   the event-loop scheduling, stream controller abstraction, or iteration logic scales poorly under pressure. This can
///   severely impact the application's responsiveness when handling rapid, concurrent real-time state changes.
///
import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:minimals_state_manager/min_notifiers.dart';

// --- BENCHMARK CONCRETE IMPLEMENTATIONS ---

class BenchmarkMinNotifier extends MinNotifier {
  int value = 0;

  void increment() {
    value++;
    notifyListeners(); // Executa o despacho síncrono nativo do Minimals
  }
}

class BenchmarkCubit extends Cubit<int> {
  BenchmarkCubit() : super(0);
  void increment() => emit(state + 1);
}

// --- BENCHMARK HARNESSES ---

class MinimalsMultiListenerBenchmark extends BenchmarkBase {
  MinimalsMultiListenerBenchmark()
      : super('Minimals (MinNotifier) [1k Listeners]');

  late BenchmarkMinNotifier notifier;
  // Guardamos as funções reais para poder removê-las depois
  final List<VoidCallback> listeners = [];

  @override
  void setup() {
    notifier = BenchmarkMinNotifier();
    for (var i = 0; i < 1000; i++) {
      void listener() {}
      notifier.addListener(listener);
      listeners.add(listener);
    }
  }

  @override
  void run() {
    notifier.increment();
  }

  @override
  void teardown() {
    for (final listener in listeners) {
      notifier.removeListener(listener);
    }
    listeners.clear();
  }

  @override
  void report() {
    final double us = measure();
    final double ms = us / 1000.0;
    print('$name: ${us.toStringAsFixed(5)} us / ${ms.toStringAsFixed(5)} ms');
  }
}

class NativeMultiListenerBenchmark extends BenchmarkBase {
  NativeMultiListenerBenchmark()
      : super('Flutter Native (ChangeNotifier) [1k Listeners]');

  late ValueNotifier<int> notifier;

  @override
  void setup() {
    notifier = ValueNotifier<int>(0);
    for (var i = 0; i < 1000; i++) {
      notifier.addListener(() {});
    }
  }

  @override
  void run() {
    notifier.value++;
  }

  @override
  void report() {
    final double us = measure();
    final double ms = us / 1000.0;
    print('$name: ${us.toStringAsFixed(5)} us / ${ms.toStringAsFixed(5)} ms');
  }
}

class BlocMultiListenerBenchmark extends BenchmarkBase {
  BlocMultiListenerBenchmark() : super('BLoC (Cubit Stream) [1k Listeners]');

  late BenchmarkCubit cubit;
  final List<dynamic> subscriptions = [];

  @override
  void setup() {
    cubit = BenchmarkCubit();
    for (var i = 0; i < 1000; i++) {
      final sub = cubit.stream.listen((state) {});
      subscriptions.add(sub);
    }
  }

  @override
  void run() {
    cubit.increment();
  }

  @override
  void teardown() {
    for (final sub in subscriptions) {
      sub.cancel();
    }
    subscriptions.clear();
    cubit.close();
  }

  @override
  void report() {
    final double us = measure();
    final double ms = us / 1000.0;
    print('$name: ${us.toStringAsFixed(5)} us / ${ms.toStringAsFixed(5)} ms');
  }
}

void main() {
  group('=== MULTI-LISTENER SCALABILITY BENCHMARKS (1,000 LISTENERS) ===', () {
    test('Execute High-Density Subscriber Dispatch Runtimes', () {
      print('=== MULTI-LISTENER SCALABILITY BENCHMARKS (1,000 LISTENERS) ===');
      print('Execute High-Density Subscriber Dispatch Runtimes \n');

      final minimalsBenchmark = MinimalsMultiListenerBenchmark()..report();
      final nativeBenchmark = NativeMultiListenerBenchmark()..report();
      final blocBenchmark = BlocMultiListenerBenchmark()..report();

      expect(minimalsBenchmark, isNotNull);
      expect(nativeBenchmark, isNotNull);
      expect(blocBenchmark, isNotNull);
    });
  });
}
