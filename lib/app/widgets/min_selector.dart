import 'package:flutter/widgets.dart';
import 'package:collection/collection.dart';

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
/// $<MyNotifier, MyNotifier>(
///   notifier: notifier,
///   selector: (notifier) => notifier,
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
  late K _oldValue;

  /// A static, performance-optimized instance for deep collection comparison.
  final _equality = const DeepCollectionEquality();

  @override
  void initState() {
    super.initState();
    _oldValue = _prepareValue(widget.selector(widget.notifier));
    widget.notifier.addListener(_valueChanged);
  }

  @override
  void didUpdateWidget(covariant $<T, K> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.notifier != widget.notifier) {
      oldWidget.notifier.removeListener(_valueChanged);
      widget.notifier.addListener(_valueChanged);
      _oldValue = _prepareValue(widget.selector(widget.notifier));
    }
  }

  @override
  void dispose() {
    widget.notifier.removeListener(_valueChanged);
    super.dispose();
  }

  /// Evaluates whether the selected value has modified.
  /// Uses [DeepCollectionEquality] for collections (Iterable/Map) and standard equality for other types.
  void _valueChanged() {
    final newValue = widget.selector(widget.notifier);

    bool hasChanged = false;

    if ((_oldValue is Iterable && newValue is Iterable) ||
        (_oldValue is Map && newValue is Map)) {
      hasChanged = !_equality.equals(_oldValue, newValue);
    } else {
      hasChanged = _oldValue != newValue;
    }

    if (hasChanged) {
      setState(() {
        _oldValue = _prepareValue(newValue);
      });
    }
  }

  /// Creates a shallow copy of collections, preserving their runtime types
  /// to safely maintain the previous state for comparison.
  dynamic _prepareValue(dynamic value) {
    if (value is List) {
      return value.toList();
    }
    if (value is Set) {
      return value.toSet();
    }
    if (value is Map) {
      return Map.from(value);
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.selector(widget.notifier));
  }
}
