import 'package:flutter/widgets.dart';
import 'package:minimals_state_manager/app/state/min_inherited_notifier.dart';
import 'package:minimals_state_manager/app/state/min_notifier.dart';

/// O Casulo: Gerencia a memória (initState/dispose) do seu ChangeNotifier

class MinProvider<T extends MinNotifier> extends StatefulWidget {
  final T Function() create;
  final Widget child;

  const MinProvider({
    Key? key,
    required this.create,
    required this.child,
  }) : super(key: key);

  @override
  State<MinProvider<T>> createState() => _MinProviderState<T>();
}

class _MinProviderState<T extends MinNotifier> extends State<MinProvider<T>> {
  late final T notifier;

  // O BLOCO ENTRA EXATAMENTE AQUI:
  @override
  void initState() {
    super.initState();
    notifier = widget.create(); // 1. Cria a instância do seu ViewModel

    notifier
        .onInit(); // 2. Dispara o onInit que você colocou no seu MinNotifier

    // 3. Espera a tela desenhar o primeiro frame e dispara o onReady com segurança
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) notifier.onReady();
    });
  }

  @override
  void dispose() {
    notifier.dispose(); // 4. Garante que morra da RAM quando der pop na tela
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MinInheritedNotifier<T>(
      notifier: notifier,
      child: widget.child,
    );
  }
}
