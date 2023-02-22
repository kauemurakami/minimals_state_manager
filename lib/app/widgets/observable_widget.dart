import 'package:flutter/widgets.dart';

/// A widget that listens to changes of a [ValueNotifier] and rebuilds its child
/// widget accordingly.
class $<T> extends StatefulWidget {
  ValueNotifier<T>? listener;
  Widget Function(T)? builder;
  Widget? child;

  /// Creates a new instance of $ widget with the provided [builder] function and
  /// [ValueNotifier] listener.
  $(this.builder, {@required this.listener, this.child, Key? key})
      : super(key: key);

  @override
  State<$<T>> createState() => _$State<T>();
}

class _$State<T> extends State<$<T>> {
  @override
  void initState() {
    if (widget.listener == null) {
      throw Exception("Listener is null");
    }
    if (widget.builder == null) {
      throw Exception("builder is null");
    }
    super.initState();
  }

  @override
  void dispose() {
    // widget.listener!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.listener!,
      builder: (context, value, child) => widget.builder!(value),
      child: widget.child,
    );
  }
}
