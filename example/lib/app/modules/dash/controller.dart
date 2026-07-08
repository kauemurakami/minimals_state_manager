import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:minimals_state_manager/min_notifiers.dart';

class DashController extends MinNotifier {
  int currentIndex = 0;

  final pages = <String>[
    'home',
    'profile',
    'other',
  ];

  @override
  void onInit() {
    print('dash controller init');
    super.onInit();
  }

  @override
  void onReady() {
    print('dash widget rendered');
    super.onReady();
  }

  goChangePage(int _, BuildContext context) async {
    currentIndex = _;
    notifyListeners();
    print(
        'route ${GoRouter.of(context).routerDelegate.currentConfiguration.fullPath}');
    context.goNamed(
      pages[currentIndex],
    );
  }

  @override
  void dispose() {
    print('dash controller dispose');
    super.dispose();
  }
}
