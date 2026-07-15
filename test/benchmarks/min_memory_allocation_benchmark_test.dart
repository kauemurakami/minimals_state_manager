/// # State Manager Lifecycle and Allocation Stress Benchmark
///
/// This benchmark measures the time and computational overhead required by each state management
/// solution to handle full resource lifecycles (instantiation, registration, mutation, and destruction).
///
/// ## What this test simulates:
/// A fast-paced navigation or runtime flow where an ephemeral notifiers/state is created,
/// has a UI listener registered, performs a data mutation, destroys the listener, and
/// disposes of itself completely. This mimics heavy interactions like scrolling infinitely
/// through complex lists or opening/closing pages rapidly.
///
/// ## Reading the Metrics:
/// * **Target Metric:** Execution runtime in microseconds (`us`) and milliseconds (`ms`).
/// * **Lower Values (BETTER):** Indicates high efficiency, a tiny memory footprint, and low
///   abstraction cost. The engine creates and disposes of resources with minimal pressure on
///   the Dart Garbage Collector (GC), avoiding runtime page stutters (jank) and lowering battery drain.
/// * **Higher Values (WORSE):** Indicates high operational overhead. Allocating internal asynchronous
///   streams, subscription structures, or dependency graphs blocks CPU threads and results in aggressive
///   GC spikes.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riverpod/riverpod.dart';
import 'package:provider/provider.dart' as pkg_provider;
import 'package:minimals_state_manager/minimals_state_manager.dart';

// --- 1. CONTROLLERS WITH DISPOSE LIFECYCLES ---

class MinMemoryController extends MinNotifier {
  int value = 0;
}

class NativeMemoryNotifier extends ChangeNotifier {
  int value = 0;
}

class BlocMemoryCubit extends Cubit<int> {
  BlocMemoryCubit() : super(0);
}

class RiverpodMemoryNotifier extends Notifier<int> {
  @override
  int build() => 0;
}

// 2. Use NotifierProvider.autoDispose referenciando o Notifier unificado
final riverpodAutodispProvider =
    NotifierProvider.autoDispose<RiverpodMemoryNotifier, int>(
        RiverpodMemoryNotifier.new);
// --- 2. BENCHMARK HARNESSES FOR LIFECYCLE STRESS ---

class MinimalsMemoryHarness extends BenchmarkBase {
  MinimalsMemoryHarness() : super('Minimals Lifecycle Stress');

  @override
  void run() {
    final controller = MinMemoryController();
    void listener() {}

    controller.addListener(listener);
    controller.value = 10;
    controller.notifyListeners();

    controller.removeListener(listener);
    controller.dispose();
  }
}

class NativeChangeNotifierHarness extends BenchmarkBase {
  NativeChangeNotifierHarness()
      : super('Flutter Native (ChangeNotifier) Lifecycle Stress');

  @override
  void run() {
    final notifier = NativeMemoryNotifier();
    void listener() {}

    notifier.addListener(listener);
    notifier.value = 10;
    notifier.notifyListeners();

    notifier.removeListener(listener);
    notifier.dispose();
  }
}

class ProviderMemoryHarness extends BenchmarkBase {
  ProviderMemoryHarness()
      : super('Provider (ChangeNotifierProvider) Lifecycle Stress');

  @override
  void run() {
    final notifier = NativeMemoryNotifier();
    pkg_provider.ChangeNotifierProvider<NativeMemoryNotifier>(
      create: (_) => notifier,
      child: const SizedBox.shrink(),
    );

    void listener() {}
    notifier.addListener(listener);
    notifier.value = 10;
    notifier.notifyListeners();

    notifier.removeListener(listener);
    notifier.dispose();
  }
}

class BlocMemoryHarness extends BenchmarkBase {
  BlocMemoryHarness() : super('BLoC Lifecycle Stress');

  @override
  void run() {
    final cubit = BlocMemoryCubit();
    final subscription = cubit.stream.listen((_) {});

    cubit.emit(10);

    subscription.cancel();
    cubit.close();
  }
}

class RiverpodMemoryHarness extends BenchmarkBase {
  RiverpodMemoryHarness() : super('Riverpod Lifecycle Stress');

  @override
  void run() {
    final container = ProviderContainer();
    final listener = container.listen(riverpodAutodispProvider, (_, __) {});

    container.read(riverpodAutodispProvider.notifier);

    listener.close();
    container.dispose();
  }
}

// --- 3. EXECUTION PATH WITH AUTO-CONVERSION ---
void main() {
  test('State Manager Lifecycle and Allocation Stress Benchmark', () {
    debugPrint(
      '=== STARTING LIFECYCLE ALLOCATION STRESS BENCHMARKS ===',
    );
    debugPrint(
      '>> Tracking microsecond/ millisecond runtime per creation/destruction cycle:',
    );

    final nativeUs = NativeChangeNotifierHarness().measure();
    final minimalsUs = MinimalsMemoryHarness().measure();
    final providerUs = ProviderMemoryHarness().measure();
    final blocUs = BlocMemoryHarness().measure();
    final riverpodUs = RiverpodMemoryHarness().measure();

    void logMetric(String name, double us) {
      double ms = us / 1000.0;
      debugPrint(
        '$name: ${us.toStringAsFixed(5)} us / ${ms.toStringAsFixed(5)} ms',
      );
    }

    logMetric('Flutter Native (ChangeNotifier)', nativeUs);
    logMetric('Minimals Lifecycle Stress', minimalsUs);
    logMetric('Provider (ChangeNotifierProvider)', providerUs);
    logMetric('BLoC Lifecycle Stress', blocUs);
    logMetric('Riverpod Lifecycle Stress', riverpodUs);

    debugPrint(
      '=== BENCHMARK EXECUTION COMPLETED ===',
    );
  });
}
