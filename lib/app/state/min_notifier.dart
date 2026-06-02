import 'package:flutter/foundation.dart';

abstract class MinNotifier extends ChangeNotifier {
  /// Chamado automaticamente assim que o Controller é criado na memória
  void onInit() {}

  /// Chamado logo após o primeiro frame da tela ser desenhado
  void onReady() {}

  /// Modifica as propriedades internas de um objeto complexo [target]
  /// e dispara a notificação para a árvore de widgets automaticamente.
  void update<K>(K target, void Function(K) action) {
    action(target);
    notifyListeners(); // Centralizado e automático!
  }
}
