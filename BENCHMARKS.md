# ⚡ Performance & Benchmarks

This document consolidates the benchmark results executed within the **Minimals State Manager** ecosystem.

## 📦 1. Lifecycle Allocation & Memory Stress
| State Manager | Runtime (μs) | Runtime (ms) | Multiplier (CPU Efficiency) |
| :--- | :--- | :--- | :--- |
| **Minimals (MinMultiProvider)** | **0.94383 us** | **0.00094 ms** | **1.0x (Baseline)** |
| **Minimals (MinProvider)** | 0.97705 us | 0.00098 ms | 1.04x slower |
| Flutter Native (`ChangeNotifier`) | 0.94838 us | 0.00095 ms | 1.01x slower |
| Provider (`ChangeNotifierProvider`) | 1.16302 us | 0.00116 ms | 1.23x slower |
| Provider (`MultiProvider`) | 1.95554 us | 0.00196 ms | 2.07x slower |
| All Observer Lifecycle Stress | 28.02282 us | 0.02802 ms | 29.69x slower |
| BLoC Lifecycle Stress | 198.04634 us | 0.19805 ms | 209.83x slower |
| Riverpod Lifecycle Stress | 230.10572 us | 0.23011 ms | 243.80x slower |

---

## ⚡ 2. High-Frequency Mutation Stress Test (100k Mutations)
| State Manager | Runtime (μs) | Runtime (ms) | Multiplier (CPU Efficiency) |
| :--- | :--- | :--- | :--- |
| **Minimals (100k Mutations)** | **15694.59231 us** | **15.69459 ms** | **1.0x (Baseline)** |
| Flutter Native (100k Mutations) | 15450.02239 us | 15.45002 ms | 0.98x (Identical) |
| BLoC (100k Mutations) | 49603.80435 us | 49.60380 ms | 3.16x slower |
| All Observer (100k Mutations) | 2359778.00000 us | 2359.77800 ms | 150.35x slower |
| Riverpod (100k Mutations) | 4886420.50000 us | 4886.42050 ms | 311.34x slower |

---

## 🎯 3. UI Rebuild Isolation and Scope Precision
| State Manager | Selector Strategy | Total UI Rebuilds | Precision Status |
| :--- | :--- | :--- | :--- |
| **Minimals** | Selector (`$`) | 1001 | 100% Precise |
| BLoC | `BlocBuilder` | 1001 | 100% Precise |
| Flutter Native | `setState` (Scoped) | 1001 | 100% Precise |
| Riverpod | `Consumer` | 1001 | 100% Precise |
| All Observer | `Observer` | 1001 | 100% Precise |

---

## 📦 4. Service Locator Dependency Injection (DI)
**On-Demand Factory Evaluation (Lazy Singletons)**
| DI Engine | Runtime (μs) | Runtime (ms) | Multiplier (CPU Efficiency) |
| :--- | :--- | :--- | :--- |
| **Minimals (MinService)** | **2.81130 us** | **0.00281 ms** | **1.0x (Baseline)** |
| GetIt - Lazy Singleton | 10.40901 us | 0.01041 ms | 3.70x slower |

**Pre-Allocated Map Lookups (Ready Singletons)**
| DI Engine | Runtime (μs) | Runtime (ms) | Multiplier (CPU Efficiency) |
| :--- | :--- | :--- | :--- |
| **Minimals (MinService)** | **2.79872 us** | **0.00280 ms** | **1.0x (Baseline)** |
| GetIt - Ready Singleton | 11.53752 us | 0.01154 ms | 4.12x slower |

---

## ⚛️ 5. Atomic State Notification Cycle
| State Manager | Runtime (μs) | Runtime (ms) | Multiplier (CPU Efficiency) |
| :--- | :--- | :--- | :--- |
| **Minimals (MinNotifier)** | **0.16535 us** | **0.00017 ms** | **1.0x (Baseline)** |
| Flutter Native (`ChangeNotifier`) | 0.16336 us | 0.00016 ms | 0.99x (Identical) |
| BLoC (`Cubit`) | 0.49695 us | 0.00050 ms | 3.00x slower |
| All Observer (Observable) | 24.22465 us | 0.02422 ms | 146.50x slower |
| Riverpod (Notifier) | 71.30813 us | 0.07131 ms | 431.25x slower |

---

## 6. 🌲 Deep Nested Service Injection Benchmarks (10 Layers)
| Framework / Service Engine | Runtime (us) | Runtime (ms) | Speed Factor |
| :--- | :--- | :--- | :--- |
| **Minimals (MinService)** | **0.59344 us** | **0.00059 ms** | **1.0x (Baseline)** |
| GetIt | 3.23401 us | 0.00323 ms | 5.45x slower |

---

## 7. 👥 Multi-Listener Scalability Benchmarks (1,000 Listeners)
| Framework / State Manager | Runtime (us) | Runtime (ms) | Speed Factor |
| :--- | :--- | :--- | :--- |
| **Minimals (MinNotifier)** | **28.06508 us** | **0.02807 ms** | **1.0x (Baseline)** |
| Flutter Native (`ChangeNotifier`) | 28.23812 us | 0.02824 ms | 1.01x slower |
| All Observer (Observable) | 204.12633 us | 0.20413 ms | 7.27x slower |
| BLoC (`Cubit Stream`) | 455.04834 us | 0.45505 ms | 16.21x slower |


### Run Benchmarks
```bash
flutter run test
```