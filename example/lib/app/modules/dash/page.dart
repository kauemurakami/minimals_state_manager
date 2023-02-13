import 'package:example/app/modules/cart/controller.dart';
import 'package:example/app/modules/dash/controller.dart';
import 'package:example/app/modules/home/controller.dart';
import 'package:example/app/modules/home/page.dart';
import 'package:example/app/modules/profile/controller.dart';
import 'package:example/app/modules/profile/page.dart';
import 'package:example/routes/pages.dart';
import 'package:flutter/material.dart';
import 'package:minimals_state_manager/app/provider/min_multi_provider.dart';
import 'package:minimals_state_manager/app/widgets/minx_widget.dart';
import 'package:minimals_state_manager/app/widgets/min_widget.dart';
import 'package:minimals_state_manager/app/provider/min_provider.dart';

class DashPage extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  DashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: navigatorKey,
        initialRoute: '/home',
        pages: [
          MaterialPage(
            name: '/home',
            child: MinMultiProvider(
              controllers: [
                MyController(),
                CartController(),
              ],
              child: MyPage(),
            ),
          ),
          MaterialPage(
            name: '/profile',
            child: MinProvider(
              controller: ProfileController(),
              child: ProfilePage(),
            ),
          )
        ],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case Routes.HOME:
              return MaterialPageRoute(
                  settings: RouteSettings(name: '/home'),
                  builder: (_) => MinMultiProvider(
                      controllers: [MyController(), CartController()],
                      child: MyPage()));
            case Routes.PROFILE:
              return MaterialPageRoute(
                  settings: RouteSettings(name: '/profile'),
                  builder: (_) => MinProvider(
                      controller: ProfileController(), child: ProfilePage()));
            default:
              return MaterialPageRoute(
                  builder: (_) => Scaffold(
                      body: Center(
                          child:
                              Text('No route defined for ${settings.name}'))));
          }
        },
        onPopPage: (route, result) => route.didPop(result),
      ),
      bottomNavigationBar: MinX<DashController>(
        builder: (context, controller) => $(
          (index) => BottomNavigationBar(
              onTap: (_) => controller.changePage(_, context),
              currentIndex: index,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), label: 'setttings'),
              ]),
          listener: controller.index,
        ),
      ),
    );
  }
}
