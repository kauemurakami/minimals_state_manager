import 'package:flutter/foundation.dart';

/// A universal, contextless Service Locator designed to manage any type of instance
/// (such as ChangeNotifier notifiers, pure Dart classes, HTTP clients, or repositories)
/// anywhere within your application.
///
/// ### Registering Dependencies:
/// ```dart
/// // Singleton (Instant registration)
/// MinService.instance.registerSingleton(Cartnotifier(), tag: 'cart');
///
/// // Lazy Singleton (Registered only when first accessed)
/// MinService.instance.registerLazySingleton(() => ApiService(), tag: 'api');
/// ```
///
/// ### Retrieving Dependencies:
/// ```dart
/// // Without tag
/// final service = MinService.instance.get<MyService>();
/// final service = MinService.instance.get<CartModel>();
///
/// // With tag
/// final cart = MinService.instance.get<Cartnotifier>(tag: 'cart');
/// ```
///
/// ### Using as a shortcut:
/// ```dart
/// final min = MinService.instance;
/// final notifier = min<Cartnotifier>(tag: 'cart');
/// final model = min<CartModel>(tag: 'cart');
/// ```
class MinService {
  static final MinService _internalInstance = MinService._();

  /// Retrieves the static singleton instance of [MinService].
  static MinService get instance => _internalInstance;

  MinService._();

  // Registry for active instances: (Type, Tag) -> Instance
  final Map<(Type, String?), Object> _instances = {};

  // Registry for lazy builders: (Type, Tag) -> Builder
  final Map<(Type, String?), Object Function()> _builders = {};

  /// Allows callable shortcut usage.
  ///
  /// Example: `min<Mynotifier>(tag: 'admin');`
  T call<T extends Object>({String? tag}) => get<T>(tag: tag);

  /// Registers and stores an instance permanently in memory immediately.
  ///
  /// If [tag] is provided, this instance will be uniquely identified by its
  /// type and that specific tag.
  T registerSingleton<T extends Object>(T instance, {String? tag}) {
    _instances[(T, tag)] = instance;
    return instance;
  }

  /// Registers a service lazily by storing its builder function.
  ///
  /// The builder is only executed when [get] is called for the first time
  /// with the matching [tag].
  void registerLazySingleton<T extends Object>(T Function() builder,
      {String? tag}) {
    _builders[(T, tag)] = builder;
  }

  /// Retrieves the registered instance of type [T].
  ///
  /// If [tag] is provided, it specifically searches for the instance
  /// registered with that tag. If no [tag] is provided, it retrieves the
  /// untagged instance.
  ///
  /// Throws an [Exception] if the requested type (or tag) has not been registered.
  T get<T extends Object>({String? tag}) {
    final key = (T, tag);

    // Try to build lazily if instance is missing
    if (!_instances.containsKey(key) && _builders.containsKey(key)) {
      _instances[key] = _builders[key]!();
    }

    if (!_instances.containsKey(key)) {
      final tagMsg = tag != null ? ' with tag "$tag"' : ' without a tag';
      throw Exception('MinService: Instance of type $T$tagMsg was not found. '
          'Ensure you registered it using registerSingleton<$T>(..., tag: "$tag") '
          'or registerLazySingleton<$T>(..., tag: "$tag").');
    }

    return _instances[key] as T;
  }

  /// Checks whether an active physical instance of type [T] (optionally with [tag])
  /// is currently alive in memory.
  bool exists<T extends Object>({String? tag}) {
    return _instances.containsKey((T, tag));
  }

  /// Disposes and completely removes the instance of type [T] from memory.
  ///
  /// If [tag] is provided, only that specific instance is destroyed.
  void destroy<T extends Object>({String? tag}) {
    final key = (T, tag);
    if (_instances.containsKey(key)) {
      final instance = _instances[key];
      if (instance is ChangeNotifier) {
        instance.dispose();
      } else {
        try {
          (instance as dynamic).dispose();
        } catch (_) {}
      }
      _instances.remove(key);
    }
    _builders.remove(key);
  }

  /// Clears all registered active services and lazy builders.
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

  /// Resets the locator, identical to [destroyAll].
  void reset() => destroyAll();
}
