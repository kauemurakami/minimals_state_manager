import 'package:example/app/core/utils/navigation/transitions/slide_from.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class CustomVerticalTransition extends CustomTransitionPage<void> {
  final SlideFrom slideFromTop;

  CustomVerticalTransition({
    super.key,
    required Widget child,
    this.slideFromTop = SlideFrom.top,
  }) : super(
          child: child,
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (_, animation, __, child) {
            final tween = slideFromTop == SlideFrom.top
                ? Tween(begin: const Offset(0, -1.5), end: Offset.zero)
                : Tween(begin: const Offset(0, 1.5), end: Offset.zero);

            return SlideTransition(
              position: animation.drive(
                tween.chain(CurveTween(curve: Curves.ease)),
              ),
              child: child,
            );
          },
        );
}
