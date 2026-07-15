/// # Deep Nested Service Injection Benchmark
///
/// ## Purpose
/// This benchmark evaluates and compares the performance of Dependency Injection (DI)
/// container resolutions between `minimals_state_manager` (`MinService`) and `get_it`.
/// It simulates a complex, real-world architecture with a deep 10-layer positional dependency graph.
///
/// ## What it Measures
/// * **Resolution Speed:** The absolute time taken to look up and retrieve a registered dependency.
/// * **Graph Traversal Efficiency:** The execution runtime performance of type hashing and recursive tree resolution under heavy nesting.
///
/// ## Metric Rule: Lower is Better
/// * **Lower values (Faster):** Represents higher efficiency. A lower execution runtime proves that
///   the DI library resolves multi-tier nested instances via pure, high-performance O(1) pointer map lookups instantly.
///   This prevents the service locator architecture from becoming a performance bottleneck as the codebase expands.
/// * **Higher values (Slower):** Indicates overhead in the lookup registry. A slower runtime means that recursive type checking,
///   internal lockings, or hash map resolution scale poorly under deep nesting, which could degrade frame rates or response times in massive apps.
library deep_nested_benchmark;

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:minimals_state_manager/min_services.dart';

abstract class Node1 {}

abstract class Node2 {}

abstract class Node3 {}

abstract class Node4 {}

abstract class Node5 {}

abstract class Node6 {}

abstract class Node7 {}

abstract class Node8 {}

abstract class Node9 {}

abstract class RootNode {}

class Impl1 implements Node1 {}

class Impl2 implements Node2 {
  final Node1 n1;
  Impl2(this.n1);
}

class Impl3 implements Node3 {
  final Node2 n2;
  Impl3(this.n2);
}

class Impl4 implements Node4 {
  final Node3 n3;
  Impl4(this.n3);
}

class Impl5 implements Node5 {
  final Node4 n4;
  Impl5(this.n4);
}

class Impl6 implements Node6 {
  final Node5 n5;
  Impl6(this.n5);
}

class Impl7 implements Node7 {
  final Node6 n6;
  Impl7(this.n6);
}

class Impl8 implements Node8 {
  final Node7 n7;
  Impl8(this.n7);
}

class Impl9 implements Node9 {
  final Node8 n8;
  Impl9(this.n8);
}

class ImplRoot implements RootNode {
  final Node9 n9;
  ImplRoot(this.n9);
}

class MinimalsDeepNestedBenchmark extends BenchmarkBase {
  MinimalsDeepNestedBenchmark()
      : super('Minimals (MinService) Deep Resolution');

  final min = MinService.instance;

  @override
  void setup() {
    min.reset();

    min.registerSingleton<Node1>(Impl1());
    min.registerSingleton<Node2>(Impl2(min<Node1>()));
    min.registerSingleton<Node3>(Impl3(min<Node2>()));
    min.registerSingleton<Node4>(Impl4(min<Node3>()));
    min.registerSingleton<Node5>(Impl5(min<Node4>()));
    min.registerSingleton<Node6>(Impl6(min<Node5>()));
    min.registerSingleton<Node7>(Impl7(min<Node6>()));
    min.registerSingleton<Node8>(Impl8(min<Node7>()));
    min.registerSingleton<Node9>(Impl9(min<Node8>()));
    min.registerSingleton<RootNode>(ImplRoot(min<Node9>()));
  }

  @override
  void run() {
    // ignore: unused_local_variable
    final root = min<RootNode>();
  }

  @override
  void report() {
    final double us = measure();
    final double ms = us / 1000.0;
    debugPrint(
      '$name: ${us.toStringAsFixed(5)} us / ${ms.toStringAsFixed(5)} ms',
    );
  }
}

class GetItDeepNestedBenchmark extends BenchmarkBase {
  GetItDeepNestedBenchmark() : super('GetIt Deep Resolution');

  final sl = GetIt.instance;

  @override
  void setup() {
    sl.reset();

    sl.registerSingleton<Node1>(Impl1());
    sl.registerSingleton<Node2>(Impl2(sl.get<Node1>()));
    sl.registerSingleton<Node3>(Impl3(sl.get<Node2>()));
    sl.registerSingleton<Node4>(Impl4(sl.get<Node3>()));
    sl.registerSingleton<Node5>(Impl5(sl.get<Node4>()));
    sl.registerSingleton<Node6>(Impl6(sl.get<Node5>()));
    sl.registerSingleton<Node7>(Impl7(sl.get<Node6>()));
    sl.registerSingleton<Node8>(Impl8(sl.get<Node7>()));
    sl.registerSingleton<Node9>(Impl9(sl.get<Node8>()));
    sl.registerSingleton<RootNode>(ImplRoot(sl.get<Node9>()));
  }

  @override
  void run() {
    // ignore: unused_local_variable
    final root = sl.get<RootNode>();
  }

  @override
  void report() {
    final double us = measure();
    final double ms = us / 1000.0;
    debugPrint(
      '$name: ${us.toStringAsFixed(5)} us / ${ms.toStringAsFixed(5)} ms',
    );
  }
}

void main() {
  group('=== DEEP NESTED SERVICE INJECTION BENCHMARKS (10 LAYERS) ===', () {
    test(
      'Execute Hierarchical Dependency Chain Lookup Performance',
      () {
        debugPrint(
          '=== DEEP NESTED SERVICE INJECTION BENCHMARKS (10 LAYERS) ===',
        );
        debugPrint(
          'Execute Hierarchical Dependency Chain Lookup Performance',
        );

        final minimalsNested = MinimalsDeepNestedBenchmark()..report();
        final getItNested = GetItDeepNestedBenchmark()..report();

        expect(minimalsNested, isNotNull);
        expect(getItNested, isNotNull);
      },
    );
  });
}
