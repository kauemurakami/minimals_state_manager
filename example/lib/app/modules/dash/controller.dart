import 'package:example/app/data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:minimals_state_manager/app/state/min_notifier.dart';

class DashController extends MinNotifier {
  int currentIndex = 0;
  // or final index = 0.minx;

  // final pages = [
  //   DashRoutes.home,
  //   DashRoutes.profile,
  //   DashRoutes.other,
  // ];

  final pages = <String>[
    'home',
    'profile',
    'other',
  ];

  DashController() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('dash widget render');
    });
    print('dash controller init');
  }

  goChangePage(int _, BuildContext context) async {
    currentIndex = _;
    notifyListeners();
    print(pages[currentIndex]);
    print(
        'aqui ${GoRouter.of(context).routerDelegate.currentConfiguration.fullPath}');
    // await GoRouter.of(context).pushNamed(pages[_]);
    context.goNamed(
      pages[currentIndex],
    );
  }
}
