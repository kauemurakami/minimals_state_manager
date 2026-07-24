/// # Dependency Injection and Service Locator Benchmark
///
/// This benchmark isolates and measures the performance difference between various dependency
/// injection (DI) strategies, comparing Minimals (`MinService`) directly against `GetIt`.
///
/// ## Test Architecture:
/// 1. **Lazy Singletons:** Evaluates lookup efficiency when dependencies are instantiated only
///    on their first request via factory definitions.
/// 2. **Ready Singletons:** Evaluates raw retrieval speed from memory maps for pre-allocated instances.
/// 3. **Async Singletons:** Evaluates execution and caching overhead for asynchronous initializations.
///
/// ## Reading the Metrics:
/// * **Target Metric:** Execution runtime in microseconds (`us`) and milliseconds (`ms`).
/// * **Lower Values (BETTER):** Indicates a highly optimized map lookup pipeline.
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:get_it/get_it.dart';
import 'package:minimals_state_manager/minimals_state_manager.dart';

// --- 1. MOCK SERVICES FOR TEST SCENARIOS ---
class DatabaseService {}

class AuthService extends ChangeNotifier {}

class ApiService extends MinNotifier {}

// --- 2. BENCHMARK HARNESSES FOR LAZY SINGLETONS ---

class MinServiceLazyHarness extends BenchmarkBase {
  MinServiceLazyHarness() : super('Minimals (MinService) - Lazy Singleton');

  @override
  void setup() {
    MinService.instance.reset();
    final min = MinService.instance;
    min.registerLazySingleton(() => DatabaseService());
    min.registerLazySingleton(() => AuthService());
    min.registerLazySingleton(() => ApiService());
  }

  @override
  void run() {
    // ignore: unused_local_variable
    final db = MinService.instance.get<DatabaseService>();
    // ignore: unused_local_variable
    final auth = MinService.instance.get<AuthService>();
    // ignore: unused_local_variable
    final api = MinService.instance.get<ApiService>();
  }

  @override
  void teardown() {
    MinService.instance.reset();
  }
}

class GetItLazyHarness extends BenchmarkBase {
  GetItLazyHarness() : super('GetIt - Lazy Singleton');

  @override
  void setup() {
    GetIt.instance.reset(dispose: false);
    final getIt = GetIt.instance;
    getIt.registerLazySingleton(() => DatabaseService());
    getIt.registerLazySingleton(() => AuthService());
    getIt.registerLazySingleton(() => ApiService());
  }

  @override
  void run() {
    // ignore: unused_local_variable
    final db = GetIt.instance.get<DatabaseService>();
    // ignore: unused_local_variable
    final auth = GetIt.instance.get<AuthService>();
    // ignore: unused_local_variable
    final api = GetIt.instance.get<ApiService>();
  }

  @override
  void teardown() {
    GetIt.instance.reset(dispose: false);
  }
}

// --- 3. BENCHMARK HARNESSES FOR READY SINGLETONS ---

class MinServiceReadyHarness extends BenchmarkBase {
  MinServiceReadyHarness() : super('Minimals (MinService) - Ready Singleton');

  @override
  void setup() {
    MinService.instance.reset();
    final min = MinService.instance;
    min.registerSingleton<DatabaseService>(DatabaseService());
    min.registerSingleton<AuthService>(AuthService());
    min.registerSingleton<ApiService>(ApiService());
  }

  @override
  void run() {
    // ignore: unused_local_variable
    final db = MinService.instance.get<DatabaseService>();
    // ignore: unused_local_variable
    final auth = MinService.instance.get<AuthService>();
    // ignore: unused_local_variable
    final api = MinService.instance.get<ApiService>();
  }

  @override
  void teardown() {
    MinService.instance.reset();
  }
}

class GetItReadyHarness extends BenchmarkBase {
  GetItReadyHarness() : super('GetIt - Ready Singleton');

  @override
  void setup() {
    GetIt.instance.reset(dispose: false);
    final getIt = GetIt.instance;
    getIt.registerSingleton<DatabaseService>(DatabaseService());
    getIt.registerSingleton<AuthService>(AuthService());
    getIt.registerSingleton<ApiService>(ApiService());
  }

  @override
  void run() {
    // ignore: unused_local_variable
    final db = GetIt.instance.get<DatabaseService>();
    // ignore: unused_local_variable
    final auth = GetIt.instance.get<AuthService>();
    // ignore: unused_local_variable
    final api = GetIt.instance.get<ApiService>();
  }

  @override
  void teardown() {
    GetIt.instance.reset(dispose: false);
  }
}

// --- 4. BENCHMARK HARNESSES FOR ASYNC SINGLETONS ---

class MinServiceAsyncHarness extends BenchmarkBase {
  MinServiceAsyncHarness() : super('Minimals (MinService) - Async Singleton');

  @override
  void setup() {
    MinService.instance.reset();
    final min = MinService.instance;
    min.registerSingletonAsync(() async => DatabaseService());
    min.registerSingletonAsync(() async => AuthService());
    min.registerSingletonAsync(() async => ApiService());
  }

  @override
  void run() {}

  @override
  void teardown() {
    MinService.instance.reset();
  }
}

class GetItAsyncHarness extends BenchmarkBase {
  GetItAsyncHarness() : super('GetIt - Async Singleton');

  @override
  void setup() {
    GetIt.instance.reset(dispose: false);
    final getIt = GetIt.instance;
    getIt.registerSingletonAsync(() async => DatabaseService());
    getIt.registerSingletonAsync(() async => AuthService());
    getIt.registerSingletonAsync(() async => ApiService());
  }

  @override
  void run() {}

  @override
  void teardown() {
    GetIt.instance.reset(dispose: false);
  }
}

// --- 5. BENCHMARK HARNESSES FOR LAZY ASYNC SINGLETONS ---

class MinServiceLazyAsyncHarness extends BenchmarkBase {
  MinServiceLazyAsyncHarness()
      : super('Minimals (MinService) - Lazy Async Singleton');

  @override
  void setup() {
    MinService.instance.reset();
    final min = MinService.instance;
    min.registerLazySingletonAsync(() async => DatabaseService());
    min.registerLazySingletonAsync(() async => AuthService());
    min.registerLazySingletonAsync(() async => ApiService());
  }

  @override
  void run() {}

  @override
  void teardown() {
    MinService.instance.reset();
  }
}

class GetItLazyAsyncHarness extends BenchmarkBase {
  GetItLazyAsyncHarness() : super('GetIt - Lazy Async Singleton');

  @override
  void setup() {
    GetIt.instance.reset(dispose: false);
    final getIt = GetIt.instance;
    getIt.registerLazySingletonAsync(() async => DatabaseService());
    getIt.registerLazySingletonAsync(() async => AuthService());
    getIt.registerLazySingletonAsync(() async => ApiService());
  }

  @override
  void run() {}

  @override
  void teardown() {
    GetIt.instance.reset(dispose: false);
  }
}

// --- 6. EXECUTION PATH WITH GROUPS ---
void main() {
  void printMetric(String name, double us) {
    double ms = us / 1000.0;
    debugPrint(
        '$name: ${us.toStringAsFixed(5)} us / ${ms.toStringAsFixed(5)} ms');
  }

  group('Synchronous Benchmarks', () {
    test('Lazy & Ready Singletons Performance', () {
      debugPrint('\n=== STARTING SYNCHRONOUS SERVICE LOCATOR BENCHMARKS ===');

      debugPrint(
          '\n>> Testing Lazy Singleton Retrieval Performance (Lower is Better):');
      final getItLazyUs = GetItLazyHarness().measure();
      final minLazyUs = MinServiceLazyHarness().measure();

      printMetric('GetIt - Lazy Singleton                 ', getItLazyUs);
      printMetric('Minimals (MinService) - Lazy Singleton ', minLazyUs);

      debugPrint('\n------------------------------------------------');

      debugPrint(
          '\n>> Testing Ready Singleton Retrieval Performance (Lower is Better):');
      final getItReadyUs = GetItReadyHarness().measure();
      final minReadyUs = MinServiceReadyHarness().measure();

      printMetric('GetIt - Ready Singleton                ', getItReadyUs);
      printMetric('Minimals (MinService) - Ready Singleton', minReadyUs);

      debugPrint('\n=== SYNCHRONOUS BENCHMARKS COMPLETED ===\n');
    });
  });

  group('Asynchronous Benchmarks', () {
    test('Async & Lazy Async Singletons Performance', () async {
      debugPrint('\n=== STARTING ASYNCHRONOUS SERVICE LOCATOR BENCHMARKS ===');

      debugPrint(
          '\n>> Testing Async Singleton Setup/Registration & Retrieval (Lower is Better):');
      final getItAsyncUs = GetItAsyncHarness().measure();
      final minAsyncUs = MinServiceAsyncHarness().measure();

      printMetric('GetIt - Async Singleton                ', getItAsyncUs);
      printMetric('Minimals (MinService) - Async Singleton', minAsyncUs);

      // Executing actual getAsync performance validation loop
      debugPrint('\n>> Testing getAsync Resolution Overhead:');
      MinService.instance.reset();
      MinService.instance.registerSingletonAsync(() async => DatabaseService());
      final stopwatchMinAsync = Stopwatch()..start();
      for (int i = 0; i < 1000; i++) {
        await MinService.instance.getAsync<DatabaseService>();
      }
      stopwatchMinAsync.stop();
      printMetric('Minimals (MinService) - getAsync Loop  ',
          stopwatchMinAsync.elapsedMicroseconds / 1000.0);

      GetIt.instance.reset(dispose: false);
      GetIt.instance.registerSingletonAsync(() async => DatabaseService());
      await GetIt.instance.allReady();
      final stopwatchGetItAsync = Stopwatch()..start();
      for (int i = 0; i < 1000; i++) {
        await GetIt.instance.getAsync<DatabaseService>();
      }
      stopwatchGetItAsync.stop();
      printMetric('GetIt - getAsync Loop                  ',
          stopwatchGetItAsync.elapsedMicroseconds / 1000.0);

      debugPrint('\n------------------------------------------------');

      debugPrint(
          '\n>> Testing Lazy Async Singleton Setup Performance (Lower is Better):');
      final getItLazyAsyncUs = GetItLazyAsyncHarness().measure();
      final minLazyAsyncUs = MinServiceLazyAsyncHarness().measure();

      printMetric('GetIt - Lazy Async Singleton           ', getItLazyAsyncUs);
      printMetric('Minimals (MinService) - Lazy Async     ', minLazyAsyncUs);

      debugPrint('\n=== ASYNCHRONOUS BENCHMARKS COMPLETED ===\n');
    });
  });
}
