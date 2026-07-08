import 'package:flutter_test/flutter_test.dart';
import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:get_it/get_it.dart';
import 'package:minimals_state_manager/minimals_state_manager.dart';

// --- 1. MOCK SERVICES FOR TEST SCENARIOS ---
class DatabaseService {}

class AuthService {}

class ApiService {}

// --- 2. BENCHMARK HARNESSES FOR LAZY SINGLETONS ---

class MinServiceLazyHarness extends BenchmarkBase {
  MinServiceLazyHarness() : super('Minimals (MinService) - Lazy Singleton');

  @override
  void setup() {
    // Clear any previous registrations before setting up to ensure clean state
    MinService.instance.reset();

    final min = MinService.instance;
    min.registerLazySingleton(() => DatabaseService());
    min.registerLazySingleton(() => AuthService());
    min.registerLazySingleton(() => ApiService());
  }

  @override
  void run() {
    // Simulates continuous retrieval of lazy initialized services
    final db = MinService.instance<DatabaseService>();
    final auth = MinService.instance<AuthService>();
    final api = MinService.instance<ApiService>();
  }

  @override
  void teardown() {
    // Reset service locator state after benchmark completion
    MinService.instance.reset();
  }
}

class GetItLazyHarness extends BenchmarkBase {
  GetItLazyHarness() : super('GetIt - Lazy Singleton');

  @override
  void setup() {
    // Force immediate synchronous reset to prevent duplicate registration crashes during harness loops
    GetIt.instance.reset(dispose: false);

    final getIt = GetIt.instance;
    getIt.registerLazySingleton(() => DatabaseService());
    getIt.registerLazySingleton(() => AuthService());
    getIt.registerLazySingleton(() => ApiService());
  }

  @override
  void run() {
    // Simulates continuous retrieval of lazy initialized services
    final db = GetIt.instance<DatabaseService>();
    final auth = GetIt.instance<AuthService>();
    final api = GetIt.instance<ApiService>();
  }

  @override
  void teardown() {
    // Reset GetIt state after benchmark completion
    GetIt.instance.reset(dispose: false);
  }
}

// --- 3. BENCHMARK HARNESSES FOR READY SINGLETONS ---

class MinServiceReadyHarness extends BenchmarkBase {
  MinServiceReadyHarness() : super('Minimals (MinService) - Ready Singleton');

  @override
  void setup() {
    // Clear any previous registrations before setting up to ensure clean state
    MinService.instance.reset();

    final min = MinService.instance;
    min.registerSingleton<DatabaseService>(DatabaseService());
    min.registerSingleton<AuthService>(AuthService());
    min.registerSingleton<ApiService>(ApiService());
  }

  @override
  void run() {
    // Simulates raw lookup speed of pre-instantiated structures
    final db = MinService.instance<DatabaseService>();
    final auth = MinService.instance<AuthService>();
    final api = MinService.instance<ApiService>();
  }

  @override
  void teardown() {
    // Reset service locator state after benchmark completion
    MinService.instance.reset();
  }
}

class GetItReadyHarness extends BenchmarkBase {
  GetItReadyHarness() : super('GetIt - Ready Singleton');

  @override
  void setup() {
    // Force immediate synchronous reset to prevent duplicate registration crashes during harness loops
    GetIt.instance.reset(dispose: false);

    final getIt = GetIt.instance;
    getIt.registerSingleton<DatabaseService>(DatabaseService());
    getIt.registerSingleton<AuthService>(AuthService());
    getIt.registerSingleton<ApiService>(ApiService());
  }

  @override
  void run() {
    // Simulates raw lookup speed of pre-instantiated structures
    final db = GetIt.instance<DatabaseService>();
    final auth = GetIt.instance<AuthService>();
    final api = GetIt.instance<ApiService>();
  }

  @override
  void teardown() {
    // Reset GetIt state after benchmark completion
    GetIt.instance.reset(dispose: false);
  }
}

// --- 4. EXECUTION PATH ---
void main() {
  test('Dependency Injection / Service Locator Benchmark', () {
    print('\n=== STARTING SERVICE LOCATOR BENCHMARKS ===');

    // Test Category 1: Lazy Singletons (Instantiated on first call)
    print('\n>> Testing Lazy Singleton Retrieval Performance:');
    GetItLazyHarness().report();
    MinServiceLazyHarness().report();

    print('------------------------------------------------');

    // Test Category 2: Ready Singletons (Pre-allocated instances)
    print('\n>> Testing Ready Singleton Retrieval Performance:');
    GetItReadyHarness().report();
    MinServiceReadyHarness().report();

    print('\n=== BENCHMARK EXECUTION COMPLETED ===\n');
  });
}
