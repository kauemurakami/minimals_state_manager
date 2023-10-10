// import 'package:flutter/widgets.dart';
// import 'package:minimals_state_manager/app/state_manager/controller/min_controller.dart';

// class MinService<T extends MinController> extends MinController {
//   static Map<Type, MinController> _instances = {};

//   MinService() : super();

//   // Cria ou retorna a instância única da classe genérica.
//   T getInstance({bool isPermanent = false}) {
//     if (!_instances.containsKey(T)) {
//       if (isPermanent) {
//         _instances[T] = _createPermanentInstance();
//       } else {
//         _instances[T] = T();
//       }
//     }
//     return _instances[T] as T;
//   }

//   // Encontra a instância única da classe genérica, se existir.
//   T? findInstance() {
//     if (_instances.containsKey(T)) {
//       return _instances[T] as T;
//     }
//     return null;
//   }

//   // Destrói a instância única da classe genérica.
//   void destroyInstance() {
//     if (_instances.containsKey(T)) {
//       _instances[T]?.onClose();
//       _instances.remove(T);
//     }
//   }

//   // Cria uma instância permanente da classe genérica.
//   T _createPermanentInstance() {
//     final instance = T();
//     instance.onInit();
//     WidgetsBinding.instance.addObserver(instance);
//     return instance;
//   }

//   // Sobrescreve o método onClose para remover a instância da lista de instâncias quando for destruída.
//   @override
//   void onClose() {
//     super.onClose();
//     _instances.remove(runtimeType);
//     WidgetsBinding.instance.removeObserver(this);
//   }
// }
