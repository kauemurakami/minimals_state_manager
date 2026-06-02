import 'package:flutter/foundation.dart';

class MinService<T extends ChangeNotifier> {
  static final Map<Type, MinService<ChangeNotifier>> _instances = {};

  final T _controller;

  MinService._internal(this._controller);

  factory MinService(T controller) {
    if (_instances.containsKey(T)) {
      return _instances[T]! as MinService<T>;
    } else {
      final instance = MinService._internal(controller);
      _instances[T] = instance;
      return instance;
    }
  }

  static T of<T extends ChangeNotifier>() {
    final type = T;
    assert(_instances.containsKey(type),
        'MinService<$T> has not been initialized.');
    return _instances[type]!.controller as T;
  }

  static ChangeNotifier permanentController<T extends ChangeNotifier>(
      T controller) {
    final type = T;

    // print('test instance minservice ${_instances[T]?.controller}');
    if (!_instances.containsKey(type)) {
      _instances[type] = MinService<T>(controller);
    }
    return _instances[T]!.controller as T;
  }

  T get controller => _controller;

  static void destroy<T extends ChangeNotifier>() {
    final type = T;
    if (_instances.containsKey(type)) {
      _instances[type]!.controller.dispose();
      _instances.remove(type);
    }
  }
}
