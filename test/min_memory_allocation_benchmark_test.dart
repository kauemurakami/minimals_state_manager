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

class RiverpodMemoryNotifier extends AutoDisposeNotifier<int> {
  @override
  int build() => 0;
}

final riverpodAutodispProvider =
    AutoDisposeNotifierProvider<RiverpodMemoryNotifier, int>(
        RiverpodMemoryNotifier.new);

// --- 2. BENCHMARK HARNESSES FOR LIFECYCLE STRESS ---

class MinimalsMemoryHarness extends BenchmarkBase {
  MinimalsMemoryHarness() : super('Minimals Lifecycle Stress');

  @override
  void run() {
    final controller = MinMemoryController();
    final listener = () {};

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
    final listener = () {};

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
    // Simulates the internal instantiation and disposal cycle that Provider triggers
    final notifier = NativeMemoryNotifier();
    final providerElement =
        pkg_provider.ChangeNotifierProvider<NativeMemoryNotifier>(
      create: (_) => notifier,
      child: const SizedBox.shrink(),
    );

    final listener = () {};
    notifier.addListener(listener);
    notifier.value = 10;
    notifier.notifyListeners();

    notifier.removeListener(listener);
    // Explicitly disposing the controller as Provider's delegate would do when unmounting
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

// --- 3. EXECUTION PATH ---
void main() {
  test('State Manager Lifecycle and Allocation Stress Benchmark', () {
    print('\n=== STARTING LIFECYCLE ALLOCATION STRESS BENCHMARKS ===');
    print('>> Tracking microsecond runtime per creation/destruction cycle:');

    NativeChangeNotifierHarness().report();
    MinimalsMemoryHarness().report();
    ProviderMemoryHarness().report();
    BlocMemoryHarness().report();
    RiverpodMemoryHarness().report();

    print('\n=== BENCHMARK EXECUTION COMPLETED ===\n');
  });
}
