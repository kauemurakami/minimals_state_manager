# ⚡ Performance & Benchmarks

This document consolidates the benchmark results executed within the **Minimals State Manager** ecosystem. The goal of these tests is to transparently measure CPU efficiency, object allocation overhead, and notification dispatch runtimes compared to the leading solutions in the Flutter ecosystem.

> 🔬 **Benchmark Environment:** Executed using the native `benchmark_harness` infrastructure under the Dart compiler optimized for production (Release mode). The efficiency multiplier indicates how many times faster Minimals performs against its competitors ($Runtime_{Competitor} / Runtime_{Minimals}$).

---

## 📦 1. Lifecycle Allocation & Memory Stress
* **Test Type:** Object Allocation & Disposal Footprint (Lifecycle Tax).
* **Objective:** Measures the precise runtime in microseconds required to fully instantiate a state container along with its listeners, and subsequently destroy it. This test evaluates the architectural "tax" a framework imposes when creating and disposing of views, controllers, or routes frequently.
* **Metric Rule:** *Lower is better* (Lower execution runtime indicates an ultra-lightweight object initialization footprint and significantly reduced Garbage Collector pressure).

| State Manager | Runtime (μs) | Runtime (ms) | Multiplier (CPU Efficiency) |
| :--- | :--- | :--- | :--- |
| **Minimals Lifecycle Stress** | **0.95688 us** | **0.00096 ms** | **Baseline (1x)** |
| Flutter Native (`ChangeNotifier`) | 0.94361 us | 0.00094 ms | 0.98x (Identical) |
| Provider (`ChangeNotifierProvider`) | 1.14585 us | 0.00115 ms | 1.19x slower |
| Riverpod Lifecycle Stress | 120.68165 us | 0.12068 ms | 126.12x slower |
| BLoC Lifecycle Stress | 192.49009 us | 0.19249 ms | 201.16x slower |

---

## ⚡ 2. High-Frequency Mutation Stress Test
* **Test Type:** Direct State Mutation Throughput.
* **Objective:** Evaluates the internal core processing speed under a heavy, continuous loop of 100,000 rapid, back-to-back state mutations. This simulates extreme real-time data streaming workloads, such as processing active WebSockets, handling high-fps animations, or parsing high-frequency hardware sensor feeds.
* **Metric Rule:** *Lower is better* (Lower execution runtime indicates maximum throughput capacity without throttling or dropping frames).

| State Manager | Runtime (μs) | Runtime (ms) | Multiplier (CPU Efficiency) |
| :--- | :--- | :--- | :--- |
| **Minimals (100k Mutations)** | **15255.23881 us** | **15.25524 ms** | **Baseline (1x)** |
| Flutter Native (100k Mutations) | 15405.04478 us | 15.40504 ms | 1.01x slower |
| BLoC (100k Mutations) | 49559.40000 us | 49.55940 ms | 3.24x slower |
| Riverpod (100k Mutations) | 124016.29412 us | 124.01629 ms | 8.12x slower |

---

## 🎯 3. UI Rebuild Isolation and Scope Precision
* **Test Type:** UI Scope Targeting & Rebuild Precision.
* **Objective:** Counts the exact number of widget rebuild cycles triggered when targeted state variables undergo modifications. This ensures that the framework's selector strategy successfully isolates visual components, blocking unnecessary re-rendering cycles from leaking into parent UI scopes.
* **Metric Rule:** *Lower is better* (The count should perfectly match the exact number of data mutations; any additional rebuild represents wasted GPU/CPU layout cycles).

| State Manager | Selector Strategy | Total UI Rebuilds | Precision Status |
| :--- | :--- | :--- | :--- |
| **Minimals** | Selector (`$`) | 1001 | 100% Precise (Perfect Isolation) |
| BLoC | `BlocBuilder` | 1001 | 100% Precise (Perfect Isolation) |
| Flutter Native | `setState` (Scoped) | 1001 | 100% Precise (Perfect Isolation) |
| Riverpod | `Consumer` | 1001 | 100% Precise (Perfect Isolation) |

---

## 📦 4. Service Locator Dependency Injection (DI Container)
* **Test Type:** Memory Registry Lookup & Reference Matching Map Scan.
* **Objective:** Measures the absolute execution speed of scanning the internal registry container to retrieve a registered object dependency using `MinService` compared directly to the industry standard (`GetIt`). Divided into on-demand factory evaluation (Lazy) and pre-allocated map lookups (Ready).
* **Metric Rule:** *Lower is better* (Pure, raw O(1) pointer map retrievals prevent dependency resolution from becoming a bottleneck as your app scales to hundreds of decoupled services).

### On-Demand Factory Evaluation (Lazy Singletons)
| DI Engine | Runtime (μs) | Runtime (ms) | Multiplier (CPU Efficiency) |
| :--- | :--- | :--- | :--- |
| **Minimals (`MinService`)** | **0.75712 us** | **0.00076 ms** | **Baseline (1x)** |
| GetIt - Lazy Singleton | 10.85896 us | 0.01086 ms | 14.34x slower |

### Pre-Allocated Map Lookups (Ready Singletons)
| DI Engine | Runtime (μs) | Runtime (ms) | Multiplier (CPU Efficiency) |
| :--- | :--- | :--- | :--- |
| **Minimals (`MinService`)** | **0.76032 us** | **0.00076 ms** | **Baseline (1x)** |
| GetIt - Ready Singleton | 10.89023 us | 0.01089 ms | 14.32x slower |

---

## ⚛️ 5. Atomic State Notification Cycle
* **Test Type:** Single Event Dispatch and Notification Propagation.
* **Objective:** Isolates and evaluates the absolute minimal code execution path required by the state machine to register a single variable modification and instantly alert a single active listener. It strips away loops to inspect the raw algorithmic efficiency of the underlying callback arrays.
* **Metric Rule:** *Lower is better* (Exceptional leanness here guarantees that the application context responds with close-to-zero latency, avoiding UI micro-stutters during interactions).

| State Manager | Runtime (μs) | Runtime (ms) | Multiplier (CPU Efficiency) |
| :--- | :--- | :--- | :--- |
| **Minimals (`MinNotifier`)** | **0.16110 us** | **0.00016 ms** | **Baseline (1x)** |
| Flutter Native (`ChangeNotifier`) | 0.16072 us | 0.00016 ms | 0.99x (Identical) |
| BLoC (`Cubit`) | 0.50092 us | 0.00050 ms | 3.10x slower |
| Riverpod (`Notifier`) | 2.03051 us | 0.00203 ms | 12.60x slower |

### 6. 🌲 Deep Nested Service Injection Benchmarks (10 Layers)

> Execute Hierarchical Dependency Chain Lookup Performance

| Framework / Service Engine | Runtime (us) | Runtime (ms) | Speed Factor |
| :--- | :--- | :--- | :--- |
| **Minimals (MinService)** | **0.25658 us** | **0.00026 ms** | **1.0x (Baseline)** |
| GetIt | 3.20147 us | 0.00320 ms | 12.48x slower |

* **Objective:** Measures the architectural latency and type-graph parsing overhead when resolving a deeply chained dependency tree spanning 10 continuous layers.
* **What it tests:** The time required by the container to recursively look up, hash, and inject multiple layers of dependent services until arriving at the requested root entity.
* **Metric Rule:** *Lower is Better*. Lower execution times demonstrate highly optimized pointer lookup structures.
* **What it means:** `MinService` performs structural resolution via flat O(1) memory address mapping, executing approximately 12.5 times faster than GetIt. This guarantees that your dependency injection matrix remains close-to-zero latency even within dense, large-scale enterprise architectures.

### 7. 👥 Multi-Listener Scalability Benchmarks (1,000 Listeners)

> Execute High-Density Subscriber Dispatch Runtimes

| Framework / State Manager | Runtime (us) | Runtime (ms) | Speed Factor |
| :--- | :--- | :--- | :--- |
| **Minimals (MinNotifier)** | **28.80769 us** | **0.02881 ms** | **1.0x (Baseline)** |
| Flutter Native (`ChangeNotifier`) | 27.99434 us | 0.02799 ms | 0.97x (Identical) |
| BLoC (`Cubit Stream`) | 393.31148 us | 0.39331 ms | 13.65x slower |

* **Objective:** Measures the architectural scalability and algorithmic efficiency of the notification dispatch pipeline when a single state mutation propagates across a high-density subscriber topology (1,000 active concurrent listeners).
* **What it tests:** The execution time required to iterate through a massive array of active observers, execute their synchronous callbacks, and evaluate if the dispatch loop triggers unnecessary structural allocations or performance bottlenecks.
* **Metric Rule:** *Lower is Better*. Lower values guarantee a highly lean notification layer capable of updating complex or massive multi-widget tree configurations flawlessly.
* **What it means:** `MinNotifier` retains an identical performance envelope to Flutter's micro-optimized native core, demonstrating pure linear scalability. By completely bypassing stream-scheduling layers, it runs approximately 13.6 times faster than BLoC, ensuring close-to-zero CPU latency even under intense interface subscriber counts.

#### run tests
Open a terminal in main folder of the package and run: 

```bash
flutter test test/min_deep_nested_service_benchmark_test.dart
```
```bash
flutter test test/min_memory_allocation_benchmark_test.dart
```
```bash
flutter test test/min_multi_listener_scalability_benchmark_test.dart
```
```bash
flutter test test/min_mutation_stress_benchmark_test.dart
```
```bash
flutter test test/min_selector_benchmark_test.dart
```
```bash
flutter test test/min_service_benchmark_test.dart
```
```bash
flutter test test/mstate_notification_benchmark_test.dart
```