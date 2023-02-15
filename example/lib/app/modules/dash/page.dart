import 'package:example/app/modules/cart/controller.dart';
import 'package:example/app/modules/dash/controller.dart';
import 'package:example/app/modules/establishments/controller.dart';
import 'package:example/app/modules/establishments/page.dart';
import 'package:example/app/modules/home/controller.dart';
import 'package:example/app/modules/home/page.dart';
import 'package:example/app/modules/profile/controller.dart';
import 'package:example/app/modules/profile/page.dart';
import 'package:example/app/my_app.dart';
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
      floatingActionButton: FloatingActionButton(onPressed: () {
        final appState = context
            .findAncestorStateOfType<MyAppState>()!
            .delegate
            .setNewRoutePath(
              Uri.parse('/profile'),
            );
      }),
      body: MinX<DashController>(builder: (context, controller) {
        return Navigator(
          key: navigatorKey,
          // key: controller.navigatorKey,
          initialRoute: '/home',
          onGenerateRoute: (RouteSettings settings) {
            print(settings.name);
            switch (settings.name) {
              case Routes.HOME:
                return MaterialPageRoute(
                  settings: const RouteSettings(name: '/home'),
                  builder: (_) => MinMultiProvider(
                    controllers: [
                      HomeController(),
                      CartController(),
                    ],
                    child: MyPage(),
                  ),
                );
              case Routes.PROFILE:
                return MaterialPageRoute(
                  settings: const RouteSettings(name: '/profile'),
                  builder: (_) => MinProvider<ProfileController>(
                    create: () => ProfileController(),
                    child: const ProfilePage(),
                  ),
                );
              case Routes.ESTABLISHMENTS:
                return MaterialPageRoute(
                  settings: const RouteSettings(name: '/establishments'),
                  builder: (_) => MinProvider<EstablishmentsController>(
                    create: () => EstablishmentsController(),
                    child: EstablishmentsPage(),
                  ),
                );
              default:
                return MaterialPageRoute(
                    builder: (_) => Scaffold(
                        body: Center(
                            child: Text(
                                'No route defined for ${settings.name}'))));
            }
          },
          onPopPage: (route, result) => route.didPop(result),
        );
      }),
      bottomNavigationBar: MinX<DashController>(
        builder: (context, controller) => $(
          (index) => BottomNavigationBar(
              // onTap: (_) => navigatorKey.currentState?.pushNamed('/profile'),
              onTap: (_) => navigatorKey.currentState!.pushReplacementNamed(
                    controller.changePage(_)!,
                  ),
              currentIndex: index,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'profile'),
              ]),
          listener: controller.index,
        ),
      ),
    );
  }
}
