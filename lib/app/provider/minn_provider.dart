import 'package:flutter/material.dart';

/// 1. O Provedor Genérico (Você só escreve isso UMA vez no projeto todo)
class MinnProvider<T extends ChangeNotifier> extends InheritedNotifier<T> {
  const MinnProvider({super.key, required T viewModel, required super.child})
    : super(notifier: viewModel);

  // Atalho para pegar o ViewModel de qualquer lugar da árvore
  // Equivale ao context.watch<T>() -> reconstrói o widget quando o VM mudar
  static T watch<T extends ChangeNotifier>(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<MinnProvider<T>>();
    if (provider == null) {
      throw Exception('Nenhum Provider<$T> encontrado no contexto.');
    }
    return provider.notifier!;
  }

  // Equivale ao context.read<T>() -> apenas pega o VM para funções, não reconstrói
  static T read<T extends ChangeNotifier>(BuildContext context) {
    final element = context
        .getElementForInheritedWidgetOfExactType<MinnProvider<T>>();
    if (element == null) {
      throw Exception('Nenhum Provider<$T> encontrado no contexto.');
    }
    return (element.widget as MinnProvider<T>).notifier!;
  }
}

/// 2. As Extensões no BuildContext para ficar com a sintaxe idêntica ao pacote Provider
extension ProviderExtension on BuildContext {
  T watch<T extends ChangeNotifier>() => MinnProvider.watch<T>(this);
  T read<T extends ChangeNotifier>() => MinnProvider.read<T>(this);
}
