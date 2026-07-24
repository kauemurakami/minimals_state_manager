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
///
/// // Async Singleton
/// MinService.instance.registerSingletonAsync(() async => PrefsService()..init());
/// // or
/// min.registerSingletonAsync<LocalStorageService>(() async {
/// final localStorageService = LocalStorageService()
/// await localStorageService.init()
/// // or if you use `MinNotifier` in your Service
/// await localStorageService.onInit()
/// return localStorageService
/// }, tag: 'first);
/// ```
///
/// ### Retrieving Dependencies:
/// ```dart
/// // Without tag (Synchronous)
/// final service = MinService.instance.get<MyService>();
///
/// // Without tag (Asynchronous)
/// final localStorageService = await MinService.instance.getAsync<LocalStorageService>();
/// final localStorageService = await min.getAsync<LocalStorageService>(tag: 'first');
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

  /// Private constructor to enforce the singleton pattern.
  MinService._();

  // Registry for active instances: (Type, Tag) -> Instance
  final Map<(Type, String?), Object> _instances = {};

  // Registry for lazy builders: (Type, Tag) -> Builder
  final Map<(Type, String?), Object Function()> _builders = {};

  // Registry for async builders: (Type, Tag) -> Future<Object> Function()
  final Map<(Type, String?), Future<Object> Function()> _asyncBuilders = {};

  // Registry for pending async initialization futures to avoid duplicate calls
  final Map<(Type, String?), Future<Object>> _asyncFutures = {};

  /// Allows callable shortcut usage.
  ///
  /// Example: `min<Mynotifier>(tag: 'admin');`
  T call<T extends Object>({String? tag}) => get<T>(tag: tag);

  /// Registers and stores an instance permanently in memory immediately.
  ///
  /// If [tag] is provided, this instance will be uniquely identified by its
  /// type and that specific tag. Returns the registered [instance].
  T registerSingleton<T extends Object>(T instance, {String? tag}) {
    _instances[(T, tag)] = instance;
    return instance;
  }

  /// Registers a service lazily by storing its [builder] function.
  ///
  /// The builder is only executed when [get] is called for the first time
  /// with the matching [tag].
  void registerLazySingleton<T extends Object>(T Function() builder,
      {String? tag}) {
    _builders[(T, tag)] = builder;
  }

  /// Registers an asynchronous singleton builder using [asyncBuilder].
  ///
  /// If [tag] is provided, this builder will be uniquely identified by its
  /// type and that specific tag.
  void registerSingletonAsync<T extends Object>(
    Future<T> Function() asyncBuilder, {
    String? tag,
  }) {
    _asyncBuilders[(T, tag)] = asyncBuilder;
  }

  /// Registers an asynchronous lazy singleton builder using [asyncBuilder].
  ///
  /// The async builder is only executed when [getAsync] is called for the first time
  /// with the matching [tag].
  void registerLazySingletonAsync<T extends Object>(
    Future<T> Function() asyncBuilder, {
    String? tag,
  }) {
    _asyncBuilders[(T, tag)] = asyncBuilder;
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
    if (!_instances.containsKey(key)) {
      if (_builders.containsKey(key)) {
        _instances[key] = _builders[key]!();
      } else if (_asyncBuilders.containsKey(key)) {
        throw Exception(
            'MinService: Instance of type $T was registered asynchronously. '
            'You must use await MinService.instance.getAsync<$T>() instead of synchronous get().');
      }
    }

    if (!_instances.containsKey(key)) {
      final tagMsg = tag != null ? ' with tag "$tag"' : ' without a tag';
      throw Exception('MinService: Instance of type $T$tagMsg was not found. '
          'Ensure you registered it using registerSingleton<$T>(..., tag: "$tag") '
          'or registerLazySingleton<$T>(..., tag: "$tag").');
    }

    return _instances[key] as T;
  }

  /// Retrieves the registered instance of type [T] asynchronously.
  ///
  /// If [tag] is provided, it specifically searches for the instance
  /// registered with that tag. If no [tag] is provided, it retrieves the
  /// untagged instance.
  ///
  /// Throws an [Exception] if the requested type (or tag) has not been registered.
  Future<T> getAsync<T extends Object>({String? tag}) async {
    final key = (T, tag);

    if (_instances.containsKey(key)) {
      return _instances[key] as T;
    }

    if (_builders.containsKey(key)) {
      return get<T>(tag: tag);
    }

    if (_asyncBuilders.containsKey(key)) {
      if (_asyncFutures.containsKey(key)) {
        return await _asyncFutures[key] as T;
      }

      final future = _asyncBuilders[key]!().then((instance) {
        _instances[key] = instance;
        _asyncFutures.remove(key);
        return instance;
      });

      _asyncFutures[key] = future;
      return await future as T;
    }

    final tagMsg = tag != null ? ' with tag "$tag"' : ' without a tag';
    throw Exception('MinService: Instance of type $T$tagMsg was not found. '
        'Ensure you registered it using registerSingletonAsync or related methods.');
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
    _asyncBuilders.remove(key);
    _asyncFutures.remove(key);
  }

  /// Clears all registered active services, lazy builders, and async loaders.
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
    _asyncBuilders.clear();
    _asyncFutures.clear();
  }

  /// Resets the locator, completely identical to [destroyAll].
  void reset() => destroyAll();
}
