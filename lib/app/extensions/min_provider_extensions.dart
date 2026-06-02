import 'package:flutter/widgets.dart';
import 'package:minimals_state_manager/app/state/min_inherited_notifier.dart';
// Importa o mensageiro para saber o tipo de busca

extension ProviderExtension on BuildContext {
  /// Sintaxe: context.watch<MeuViewModel>()
  T watch<T extends ChangeNotifier>() {
    final inherited =
        dependOnInheritedWidgetOfExactType<MinInheritedNotifier<T>>();
    if (inherited == null) {
      throw Exception('Nenhum MinProvider<$T> encontrado no contexto.');
    }
    return inherited.notifier!;
  }

  /// Sintaxe: context.read<MeuViewModel>()
  T read<T extends ChangeNotifier>() {
    final element =
        getElementForInheritedWidgetOfExactType<MinInheritedNotifier<T>>();
    if (element == null) {
      throw Exception('Nenhum MinProvider<$T> encontrado no contexto.');
    }
    return (element.widget as MinInheritedNotifier<T>).notifier!;
  }
}
