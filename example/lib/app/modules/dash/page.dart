import 'package:example/app/modules/cart/controller.dart';
import 'package:example/app/modules/dash/controller.dart';
import 'package:example/app/modules/home/controller.dart';
import 'package:example/app/modules/home/page.dart';
import 'package:flutter/material.dart';
import 'package:minimals_state_manager/app/widgets/minx_widget.dart';
import 'package:minimals_state_manager/app/provider/min_provider.dart';
import 'package:minimals_state_manager/app/widgets/observable_widget.dart';

class DashPage extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final child;
  DashPage({this.child, super.key});

  @override
  Widget build(BuildContext context) {
    print('rebuild dash');
    return Scaffold(
      body: MinX<DashController>(
        builder: (context, controller) {
          return child ??
              MinProvider(
                controller: HomeController(),
                child: HomePage(),
              );
        },
      ),
      bottomNavigationBar: MinX<DashController>(
        builder: (context, controller) => $(
          (index) => BottomNavigationBar(
              selectedItemColor: Colors.amber,
              unselectedItemColor: Colors.grey,
              backgroundColor: Colors.white,
              onTap: (_) => controller.goChangePage(_, context)!,
              //change go route

              currentIndex: index,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.radar),
                  label: 'Other',
                ),
              ]),
          listener: controller.currentIndex,
        ),
      ),
    );
  }
}
