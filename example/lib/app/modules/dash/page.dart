import 'package:example/app/modules/dash/controller.dart';
import 'package:example/app/modules/home/controller.dart';
import 'package:example/app/modules/home/page.dart';
import 'package:flutter/material.dart';
import 'package:minimals_state_manager/app/provider/min_multi_provider.dart';
import 'package:minimals_state_manager/app/provider/min_provider.dart';
import 'package:minimals_state_manager/app/widgets/min_selector.dart';

class DashPage extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final child;
  DashPage({this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MinMultiProvider.read<DashController>(context);
    print('rebuild dash');
    return Scaffold(
      body: child ??
          MinProvider<HomeController>(
            create: () => HomeController(),
            child: HomePage(),
          ),
      bottomNavigationBar: $<DashController, int>(
        notifier: controller,
        selector: (notifier) => notifier.currentIndex,
        builder: (context, index) => BottomNavigationBar(
          currentIndex: index,
          selectedItemColor: Colors.amber,
          unselectedItemColor: Colors.grey,
          selectedIconTheme: const IconThemeData(color: Colors.amber),
          unselectedIconTheme: const IconThemeData(color: Colors.grey),
          backgroundColor: Colors.white,
          onTap: (_) {
            print(_);
            controller.goChangePage(_, context)!;
          },
          //change go route

          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.radar,
              ),
              label: 'Other',
            ),
          ],
        ),
      ),
    );
  }
}
