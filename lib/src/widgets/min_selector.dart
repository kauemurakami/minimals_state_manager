import 'package:flutter/widgets.dart';
import 'package:collection/collection.dart';
import 'package:minimals_state_manager/min_props.dart';

/// A highly optimized reactive widget that listens to a [Listenable] (such as
/// [MinNotifier], [ChangeNotifier], or [ValueNotifier]) and rebuilds its [builder]
/// only when the specific slice of state returned by the [selector] changes.
///
/// Under the hood, this widget uses a smart caching and evaluation mechanism
/// that supports deep structural comparisons for [Iterable], [Map], [Record],
/// and custom classes extending [MinProps] (without requiring `copyWith` boilerplate).
///
/// ### Core Features:
/// * **Deep Collection Comparison:** Detects deep changes within lists, maps, and sets.
/// * **Structural Record Evaluation:** Evaluates inline and typed Dart 3 Records.
/// * **Boilerplate-free Model Tracking:** Automatically monitors property updates of any
///   custom model extending [MinProps] by looking at its `.props` Record under the hood.
/// * **Listen All Mode:** Easily opts out of filtering to trigger rebuilds on absolutely
///   any state emission.
///
/// ---
///
/// ### Supported Scenarios & Examples:
///
/// #### 1. Filtering Primitive State Mutations
/// Rebuilds only when the targeted primitive value changes.
/// ```dart
/// $<TestNotifier, bool>(
///   notifier: context.read<TestNotifier>(),
///   selector: (notifier) => notifier.loading,
///   builder: (context, loading) {
///     return Text(loading ? 'Loading...' : 'Ready');
///   },
/// )
/// ```
///
/// #### 2. Grouping Values via Native Dart Records
/// Keeps the view updated whenever any grouped property inside the Record changes.
/// ```dart
/// $<TestNotifier, ({String name, bool loading}),>(
///   notifier: context.read<TestNotifier>(),
///   selector: (notifier) => (name: notifier.user.name, loading: notifier.loading),
///   builder: (context, data) {
///     return Text('${data.name} -${data.loading ? 'Active' : 'Inactive'}');
///   },
/// )
/// ```
///
/// #### 3. Complex Structural Models (via `MinProps`)
/// Passes the complex model directly to the builder while automatically monitoring
/// its internal values using its `.props` Record in the background.
/// ```dart
/// $<TestNotifier, User>(
///   notifier: context.read<TestNotifier>(),
///   selector: (notifier) => notifier.user, // Automatically tracks nested props!
///   builder: (context, user) {
///     return Text('User: ${user.name} \vert{}${user.email}');
///   },
/// )
/// ```
///
/// #### 4. Lists, Maps, and Sets Tracking
/// Performs deep equality checks to trigger rebuilds whenever items are added, removed,
/// or modified.
/// ```dart
/// $<TestNotifier, List<String>>(
///   notifier: context.read<TestNotifier>(),
///   selector: (notifier) => notifier.items,
///   builder: (context, items) {
///     return items.isEmpty ? Text('No items') : Text('Total: ${items.length}');
///   },
/// )
/// ```
///
/// #### 5. Listen All Changes (Notifier Stream)
/// Opts out of structural comparison to trigger a rebuild on any event emitted by the notifier.
/// ```dart
/// $<TestNotifier, TestNotifier>(
///   notifier: context.read<TestNotifier>(),
///   selector: (notifier) => notifier, // Listens to absolutely everything
///   builder: (context, notifier) {
///     return Text('Whatever value: ${notifier.whatever}');
///   },
/// )
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

  void _valueChanged() {
    final newValueRaw = widget.selector(widget.notifier);

    // USE CASE 5 (Listen All):
    // If the value returned by the selector is the notifier itself,
    // we ALWAYS force a rebuild on every notifyListeners() call.
    if (identical(newValueRaw, widget.notifier)) {
      setState(() {
        // Just update the internal state to keep the flow consistent
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

    // 1. IF IT IS AN OBJECT THAT EXTENDS MINPROPS (Your User model)
    // We extract the Record (.props) and "freeze" its values to safely monitor deep changes.
    if (value is MinProps) {
      return _extractRecordValues(value.props);
    }

    // 2. IF IT IS A DIRECT RECORD (e.g., (loading, name))
    if (value is Record) {
      return _extractRecordValues(value);
    }

    return value;
  }

  dynamic _extractRecordValues(Record record) {
    // Freezes the Record representation as a string for robust deep comparisons later
    return record.toString();
  }

  @override
  Widget build(BuildContext context) {
    // Delivers the original, typed K (User) without any dangerous casting!
    return widget.builder(context, widget.selector(widget.notifier));
  }
}
