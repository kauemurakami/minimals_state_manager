import 'package:example/app/core/utils/navigation/transitions/slide_from.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class CustomSlideTransition extends CustomTransitionPage<void> {
  CustomSlideTransition(
      {super.key, required super.child, from = SlideFrom.left})
      : super(
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: animation.drive(
                from == SlideFrom.left
                    ? Tween(begin: const Offset(-1.5, 0), end: Offset.zero)
                    : Tween(
                        begin: const Offset(1.5, 0),
                        end: Offset.zero,
                      ).chain(
                        CurveTween(curve: Curves.ease),
                      ),
              ),
              child: child,
            );
          },
        );
}
