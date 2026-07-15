/// # High-Frequency Mutation Stress Benchmark
///
/// This benchmark measures raw execution speed and dispatch efficiency when a state manager is
/// bombarded with a massive torrent of sequential data updates.
///
/// ## What this test simulates:
/// A high-frequency real-time data influx environment, such as a financial stock market feed,
/// multiplayer game networking packets, or continuous WebSocket telemetry from background sensors.
/// It triggers exactly 100,000 back-to-back state modifications to evaluate the architectural
/// limits of each solution's update propagation pipeline.
///
/// ## Reading the Metrics:
/// * **Target Metric:** Total runtime execution in microseconds (`us`) and milliseconds (`ms`).
/// * **Lower Values (BETTER):** Indicates high computational efficiency, direct sychronous processing,
///   and lightweight communication overhead. The engine dispatches data instantly without bottlenecking
///   the application's runtime flow.
/// * **Higher Values (WORSE):** Indicates severe structural overhead. Forcing thousands of continuous
///   mutations through asynchronous event buffers (Streams) or complex graph re-evaluation passes
///   locks down CPU cores, causing heavy interface micro-stutters (jank) and battery depletion.

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riverpod/riverpod.dart';
import 'package:minimals_state_manager/minimals_state_manager.dart';

// --- 1. CONTROLLERS FOR HIGH-FREQUENCY MUTATION ---

class NativeStressNotifier extends ChangeNotifier {
  int counter = 0;
  void mutate() {
    counter++;
    notifyListeners();
  }
}

class MinStressController extends MinNotifier {
  int counter = 0;
  void mutate() {
    counter++;
    notifyListeners();
  }
}

class BlocStressCubit extends Cubit<int> {
  BlocStressCubit() : super(0);
  void mutate() => emit(state + 1);
}

class RiverpodStressNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void mutate() => state = state + 1;
}

final riverpodStressProvider =
    NotifierProvider<RiverpodStressNotifier, int>(RiverpodStressNotifier.new);

// --- 2. BENCHMARK HARNESSES FOR STRESS SCENARIOS ---

class NativeMutationHarness extends BenchmarkBase {
  NativeMutationHarness() : super('Flutter Native (100k Mutations)');

  late NativeStressNotifier notifier;
  late void Function() listener;

  @override
  void setup() {
    notifier = NativeStressNotifier();
    listener = () {};
    notifier.addListener(listener);
  }

  @override
  void run() {
    for (int i = 0; i < 100000; i++) {
      notifier.mutate();
    }
  }

  @override
  void teardown() {
    notifier.removeListener(listener);
    notifier.dispose();
  }
}

class MinimalsMutationHarness extends BenchmarkBase {
  MinimalsMutationHarness() : super('Minimals (100k Mutations)');

  late MinStressController controller;
  late void Function() listener;

  @override
  void setup() {
    controller = MinStressController();
    listener = () {};
    controller.addListener(listener);
  }

  @override
  void run() {
    for (int i = 0; i < 100000; i++) {
      controller.mutate();
    }
  }

  @override
  void teardown() {
    controller.removeListener(listener);
    controller.dispose();
  }
}

class BlocMutationHarness extends BenchmarkBase {
  BlocMutationHarness() : super('BLoC (100k Mutations)');

  late BlocStressCubit cubit;
  late dynamic subscription;

  @override
  void setup() {
    cubit = BlocStressCubit();
    subscription = cubit.stream.listen((_) {});
  }

  @override
  void run() {
    for (int i = 0; i < 100000; i++) {
      cubit.mutate();
    }
  }

  @override
  void teardown() {
    subscription.cancel();
    cubit.close();
  }
}

class RiverpodMutationHarness extends BenchmarkBase {
  RiverpodMutationHarness() : super('Riverpod (100k Mutations)');

  late ProviderContainer container;
  late ProviderSubscription<int> subscription;

  @override
  void setup() {
    container = ProviderContainer();
    subscription = container.listen(riverpodStressProvider, (_, __) {});
  }

  @override
  void run() {
    final notifier = container.read(riverpodStressProvider.notifier);
    for (int i = 0; i < 100000; i++) {
      notifier.mutate();
    }
  }

  @override
  void teardown() {
    subscription.close();
    container.dispose();
  }
}

// --- 3. EXECUTION PATH WITH AUTO-CONVERSION ---
void main() {
  test('High-Frequency Mutation Stress Benchmark', () {
    debugPrint('\n=== STARTING HIGH-FREQUENCY MUTATION STRESS BENCHMARKS ===');
    debugPrint(
        '>> Measuring execution speed for 100,000 rapid back-to-back state mutations:');

    // We execute measure() directly to grab the raw double value in microseconds
    final nativeUs = NativeMutationHarness().measure();
    final minimalsUs = MinimalsMutationHarness().measure();
    final blocUs = BlocMutationHarness().measure();
    final riverpodUs = RiverpodMutationHarness().measure();

    // Helper function to debugPrint both metrics clearly
    void printMetric(String name, double us) {
      double ms = us / 1000.0;
      debugPrint(
          '$name: ${us.toStringAsFixed(5)} us / ${ms.toStringAsFixed(5)} ms');
    }

    printMetric('Flutter Native (100k Mutations)', nativeUs);
    printMetric('Minimals (100k Mutations)      ', minimalsUs);
    printMetric('BLoC (100k Mutations)          ', blocUs);
    printMetric('Riverpod (100k Mutations)      ', riverpodUs);

    debugPrint('\n=== BENCHMARK EXECUTION COMPLETED ===\n');
  });
}
