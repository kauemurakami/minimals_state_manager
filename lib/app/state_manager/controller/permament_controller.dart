import 'dart:convert';

import 'package:minimals_state_manager/app/state_manager/controller/min_controller.dart';
import 'package:minimals_state_manager/app/types/min_type_instance.dart';

// class MinService<T extends MinController> {
//   static MinService? _instance;
//   final T _controller;

//   factory MinService(T controller) {
//     _instance ??= MinService._internal(controller);
//     return _instance as MinService<T>;
//   }
//   static permanentController<T extends MinController>(T controller) {
//     _instance ??= MinService<T>(controller);
//     return _instance!.controller;
//   }

//   static void destroy() {
//     if (_instance != null) {
//       _instance!.controller.onClose();
//       _instance = null;
//     }
//   }

//   MinService._internal(this._controller);

//   T get controller => _controller;
// }

// class MinService<T extends MinController> {
//   static final Map<Type, MinService> _instances = {};
//   final T _controller;

//   factory MinService(T controller) {
//     final type = T;
//     _instances[type] ??= MinService._internal(controller);
//     return _instances[type] as MinService<T>;
//   }

//   static T permanentController<T extends MinController>() {
//     final type = T;
//     assert(_instances.containsKey(type),
//         'MinService<$T> has not been initialized.');
//     return _instances[type]!.controller as T;
//   }

//   T get controller => _controller;

//   static void destroy<T extends MinController>() {
//     final type = T;
//     if (_instances.containsKey(type)) {
//       _instances[type]!.controller.onClose();
//       _instances.remove(type);
//     }
//   }

//   MinService._internal(this._controller);
// }

class MinService<T extends MinController> with MinInstance<T> {
  static final Map<Type, MinService<MinController>> _instances = {};

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

  static T of<T extends MinController>() {
    final type = T;
    assert(_instances.containsKey(type),
        'MinService<$T> has not been initialized.');
    return _instances[type]!.controller as T;
  }

  //find or create
  // static T of<T extends MinController>({T? controller}) {
  //   final type = T;
  //   if (!_instances.containsKey(type)) {
  //     _instances[type] = MinService<T>(controller ?? T());
  //   }
  //   return _instances[type]!.controller as T;
  // }

  static MinController permanentController<T extends MinController>(
      T controller) {
    final type = T;

    print('test instance minservice ${_instances[T]?.controller}');
    if (!_instances.containsKey(type)) {
      _instances[type] = MinService<T>(controller);
    }
    return _instances[T]!.controller as T;
  }

  T get controller => _controller;

  static void destroy<T extends MinController>() {
    final type = T;
    if (_instances.containsKey(type)) {
      _instances[type]!.controller.onClose();
      _instances.remove(type);
    }
  }
}
