import 'package:flutter/widgets.dart';

class $ extends StatefulWidget {
  ValueNotifier? listener;
  Widget Function()? builder;
  Widget? child;
  $(this.builder, {@required this.listener, this.child, Key? key})
      : super(key: key);

  @override
  State<$> createState() => _$State();
}

class _$State extends State<$> {
  @override
  void initState() {
    // if (widget.listener != null && !widget.listener!.hasListeners) {
    //   throw """
    //     Adicione um listener ao widget
    //   """;
    // }
    super.initState();
  }

  @override
  void dispose() {
    widget.listener!.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.listener!,
      builder: (context, value, child) => widget.builder!(),
      child: widget.child,
    );
  }
}
