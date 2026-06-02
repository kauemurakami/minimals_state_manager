import 'package:flutter/widgets.dart';

class $<T extends Listenable, K> extends StatefulWidget {
  final T notifier;
  final K Function(T notifier) selector; // Aqui o K vira o seu Record nomeado
  final Widget Function(BuildContext context, K value)
  builder; // Aqui o K também vira o Record
  final Widget? child;
  const $({
    required this.notifier,
    required this.selector,
    required this.builder,
    this.child,
    super.key,
  });

  @override
  State<$<T, K>> createState() => _$<T, K>();
}

class _$<T extends Listenable, K> extends State<$<T, K>> {
  late K _oldValue;
  @override
  void initState() {
    super.initState();
    _oldValue = widget.selector(widget.notifier);
    widget.notifier.addListener(_valueChanged);
  }

  @override
  void didUpdateWidget(covariant $<T, K> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.notifier != widget.notifier) {
      oldWidget.notifier.removeListener(_valueChanged);
      widget.notifier.addListener(_valueChanged);
      _oldValue = widget.selector(widget.notifier);
    }
  }

  @override
  void dispose() {
    widget.notifier.removeListener(_valueChanged);
    super.dispose();
  }

  void _valueChanged() {
    final newValue = widget.selector(
      widget.notifier,
    ); // O Dart sabe comparar Records campo por campo!
    /* Ele vai checar se o UMA variavel foi alterada ou
    a instância de um 'command' mudaram.*/
    if (newValue != _oldValue) {
      setState(() {
        _oldValue = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _oldValue);
  }
}
