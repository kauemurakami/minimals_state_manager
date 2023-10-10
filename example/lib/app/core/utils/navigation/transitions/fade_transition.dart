import 'package:example/app/core/utils/navigation/transitions/slide_from.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class CustomFadeTransition extends CustomTransitionPage<void> {
  final SlideFrom fadeOut;

  CustomFadeTransition({
    super.key,
    required Widget child,
    this.fadeOut = SlideFrom.inn,
  }) : super(
          child: child,
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (_, animation, __, child) {
            final opacityTween = fadeOut == SlideFrom.out
                ? Tween(begin: 1.0, end: 0.0)
                : Tween(begin: 0.0, end: 1.0);

            return FadeTransition(
              opacity: animation.drive(
                opacityTween.chain(CurveTween(curve: Curves.ease)),
              ),
              child: child,
            );
          },
        );
}
