import 'package:flutter/material.dart'; // Import necessário para o ChangeNotifier nativo
import 'package:flutter_test/flutter_test.dart';
import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riverpod/riverpod.dart';
import 'package:minimals_state_manager/minimals_state_manager.dart';

// --- 1. IMPLEMENTAÇÃO DOS ELEMENTOS DE TESTE ---

// 1. Minimals Controller (Sua solução)
class MinalsCounterController extends MinNotifier {
  int count = 0;

  void increment() {
    count++;
    notifyListeners();
  }
}

// 2. ChangeNotifier Nativo do Flutter
class NativeCounterNotifier extends ChangeNotifier {
  int count = 0;

  void increment() {
    count++;
    notifyListeners();
  }
}

// 3. BLoC Cubit
class BlocCounterCubit extends Cubit<int> {
  BlocCounterCubit() : super(0);
  void increment() => emit(state + 1);
}

// 4. Riverpod Notifier
class RiverpodCounter extends Notifier<int> {
  @override
  int build() => 0;
  void increment() => state = state + 1;
}

final riverpodProvider =
    NotifierProvider<RiverpodCounter, int>(RiverpodCounter.new);

// --- 2. HARNESSES DO BENCHMARK ---

class MinalsHarness extends BenchmarkBase {
  late MinalsCounterController controller;
  MinalsHarness() : super('Minimals (MinNotifier)');

  @override
  void setup() {
    controller = MinalsCounterController();
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

// --- 3. EXECUÇÃO ---
void main() {
  test('Execução de Microbenchmarks de Estado', () {
    print('\n=== INICIANDO BENCHMARK DE MOTORES DE ESTADO ===');

    MinalsHarness().report();
    NativeHarness().report();
    BlocHarness().report();
    RiverpodHarness().report();

    print('================================================\n');
  });
}
