import 'package:flutter/widgets.dart';
import 'package:collection/collection.dart';
import 'package:minimals_state_manager/min_props.dart';

/// A reactive widget that listens to a [Listenable] (such as [MinNotifier], [ChangeNotifier] or [ValueNotifier])
/// and rebuilds its [builder] only when the selected value changes.
///
/// The [selector] is used to isolate a specific piece of the state. If the selected
/// value is a [List], this widget uses [DeepCollectionEquality] to detect deep
/// changes within the collection items, ensuring surgical rebuilds only when
/// the list content actually modifies.
///
/// Example:
/// ```dart
///
/// Use Iterables/Set:
/// $<MyNotifier, List<Item>>(
///   notifier: notifier,
///   selector: (notifier) => notifier.products,
///   builder: (context, list) => ListView(
///     children: list.map((item) => Text(item.name)).toList(),
///   ),
/// )
///
/// Use Records:
/// $<MyNotifier, (String name, bool loading)>(
///   notifier: notifier,
///   selector: (notifier) => (name: notifier.user.name, loading: notifier.loading),
///   builder: (context, data) => data.loading
///     ? CircularProgressIndicator() : Text(data.name)
/// )
///
/// Use primitive value:
/// $<MyNotifier, bool>(
///   notifier: notifier,
///   selector: (notifier) => notifier.loading,
///   builder: (context, loading) => loading
///     ? CircularProgressIndicator() : Text('loaded')
/// )
///
/// Use complex object (Necessary use MinProps in your model, or create your
/// property props, generating a record ):
/// $<MyNotifier, User>(
///   notifier: notifier,
///   selector: (notifier) => notifier.user.props,
///   builder: (context, user) => ...[Text(user.name), Text(user.email)]
/// )
///
/// Use only notifier to listen any changes:
/// $<MyNotifier, (MyNotifier)>(
///   notifier: notifier,
///   selector: (notifier) => (notifier),
///   builder: (context, notifier) => Text(notifier.user.name)
/// )
///
/// ```
class $<T extends Listenable, K> extends StatefulWidget {
  /// The observable object that dispatches change notifications.
  final T notifier;

  /// A function used to select the specific slice of the state to observe.
  final K Function(T notifier) selector;

  /// A function that builds the widget tree based on the selected value.
  final Widget Function(BuildContext context, K value) builder;

  const $({
    required this.notifier,
    required this.selector,
    required this.builder,
    super.key,
  });

  @override
  State<$<T, K>> createState() => _$<T, K>();
}

class _$<T extends Listenable, K> extends State<$<T, K>> {
  late dynamic _oldValue;
  final _equality = const DeepCollectionEquality();

  @override
  void initState() {
    super.initState();
    _oldValue = _prepareValue(widget.selector(widget.notifier));
    widget.notifier.addListener(_valueChanged);
  }

  // ... didUpdateWidget e dispose continuam iguais ...

  void _valueChanged() {
    final newValueRaw = widget.selector(widget.notifier);

    // CASO DE USO 5 (Listen All):
    // Se o valor retornado pelo selector for o próprio notifier,
    // nós SEMPRE forçamos o rebuild a cada notifyListeners().
    if (identical(newValueRaw, widget.notifier)) {
      setState(() {
        // Apenas atualizamos o estado interno para manter o fluxo
        _oldValue = newValueRaw;
      });
      return;
    }

    final newValuePrepared = _prepareValue(newValueRaw);
    bool hasChanged = false;

    if ((_oldValue is Iterable && newValuePrepared is Iterable) ||
        (_oldValue is Map && newValuePrepared is Map)) {
      hasChanged = !_equality.equals(_oldValue, newValuePrepared);
    } else {
      hasChanged = _oldValue != newValuePrepared;
    }

    if (hasChanged) {
      setState(() {
        _oldValue = newValuePrepared;
      });
    }
  }

  dynamic _prepareValue(dynamic value) {
    if (value is List) return value.toList();
    if (value is Set) return value.toSet();
    if (value is Map) return Map.from(value);

    // 1. SE FOR UM OBJETO QUE EXTENDE MINPROPS (Seu modelo User)
    // Nós extraímos o Record (.props) e "congelamos" ele para monitorar mudanças profundas
    if (value is MinProps) {
      return _extractRecordValues(value.props);
    }

    // 2. SE FOR UM RECORD DIRETO (Ex: (loading, name))
    if (value is Record) {
      return _extractRecordValues(value);
    }

    return value;
  }

  dynamic _extractRecordValues(Record record) {
    // Congela a representação do Record como string para comparar facilmente depois
    return record.toString();
  }

  @override
  Widget build(BuildContext context) {
    // Entrega o K (User) original e tipado sem nenhum cast perigoso!
    return widget.builder(context, widget.selector(widget.notifier));
  }
}
