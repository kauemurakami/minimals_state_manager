import 'package:flutter/foundation.dart';

/// A universal, contextless Service Locator designed to manage any type of instance
/// (such as ChangeNotifier controllers, pure Dart classes, HTTP clients, or repositories)
/// anywhere within your application.
///
/// ### Traditional Usage (via Singleton instance):
/// ```dart
/// // 1. Register your dependencies
/// MinService.instance.registerSingleton(CartController());
/// MinService.instance.registerLazySingleton(() => ApiService());
///
/// // 2. Retrieve your instances anywhere
/// final cart = MinService.instance.get<CartController>();
/// ```
///
/// ### Custom Global Alias Usage (Recommended for better DX):
/// You can define your own global shortcut in your initialization file:
/// ```dart
/// final min = MinService.instance;
///
/// // Now you can use it fluidly:
/// void setup() {
///   min.registerSingleton(CartController());
/// }
///
/// // Retrieve using the .get() method or the shortcut callable syntax:
/// final cart = min.get<CartController>();
/// final auth = min<AuthController>();
/// ```
class MinService {
  static final MinService _internalInstance = MinService._();

  /// Retrieves the static singleton instance of [MinService].
  static MinService get instance => _internalInstance;

  // Private constructor to prevent direct instantiation
  MinService._();

  final Map<Type, Object> _instances = {};
  final Map<Type, Object Function()> _builders = {};

  /// Allows callable shortcut usage when assigned to a variable or instance pointer.
  ///
  /// Example:
  /// ```dart
  /// final min = MinService.instance;
  /// final controller = min<MyController>();
  /// ```
  T call<T extends Object>() => get<T>();

  /// Registers and stores an instance permanently in memory immediately.
  T registerSingleton<T extends Object>(T instance) {
    final type = T;
    if (!_instances.containsKey(type)) {
      _instances[type] = instance;
    }
    return _instances[type] as T;
  }

  /// Registers a service lazily by storing its builder function.
  void registerLazySingleton<T extends Object>(T Function() builder) {
    _builders[T] = builder;
  }

  /// Retrieves the registered instance of type [T] without needing a BuildContext.
  T get<T extends Object>() {
    final type = T;

    if (!_instances.containsKey(type) && _builders.containsKey(type)) {
      _instances[type] = _builders[type]!();
    }

    assert(_instances.containsKey(type),
        'MinService: Instance of type $type has not been initialized. Make sure to call registerSingleton<$type>(...) or registerLazySingleton<$type>(...) first.');

    return _instances[type] as T;
  }

  /// Checks whether an active physical instance of type [T] is currently alive in memory.
  bool exists<T extends Object>() {
    return _instances.containsKey(T);
  }

  /// Disposes and completely removes the instance of type [T] from memory.
  void destroy<T extends Object>() {
    final type = T;
    if (_instances.containsKey(type)) {
      final instance = _instances[type];

      if (instance is ChangeNotifier) {
        instance.dispose();
      } else {
        try {
          (instance as dynamic).dispose();
        } catch (_) {}
      }

      _instances.remove(type);
    }
    if (_builders.containsKey(type)) {
      _builders.remove(type);
    }
  }

  /// Clears all registered active services and lazy builders running their dipose processes.
  void destroyAll() {
    for (final instance in _instances.values) {
      if (instance is ChangeNotifier) {
        instance.dispose();
      } else {
        try {
          (instance as dynamic).dispose();
        } catch (_) {}
      }
    }
    _instances.clear();
    _builders.clear();
  }

  /// Resets the locator, identical to [destroyAll], primarily for testing syntax familiarity.
  void reset() => destroyAll();
}
