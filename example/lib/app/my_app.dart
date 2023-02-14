import 'package:example/app/modules/cart/controller.dart';
import 'package:example/app/modules/dash/controller.dart';
import 'package:example/app/modules/dash/page.dart';
import 'package:example/app/modules/home/controller.dart';
import 'package:example/app/modules/home/page.dart';
import 'package:example/app/modules/profile/controller.dart';
import 'package:example/app/modules/profile/page.dart';
import 'package:example/routes/delegate.dart';
import 'package:example/routes/page.dart';
import 'package:example/routes/route_information_parser.dart';
import 'package:flutter/material.dart';
import 'package:minimals_state_manager/app/provider/min_multi_provider.dart';
import 'package:minimals_state_manager/app/provider/min_provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final delegate = MyRouterDelegate(pages: [
    AppPage(
        (_) => MinProvider(
              controller: DashController(),
              child: DashPage(),
            ),
        path: '/'),
    AppPage(
        (_) => MinMultiProvider(
            controllers: [HomeController(), CartController()], child: MyPage()),
        path: '/home'),
    AppPage(
        (_) => MinProvider(
            controller: ProfileController(), child: const ProfilePage()),
        path: '/profile')
  ]);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      // routerConfig: router,
      routerDelegate: delegate,
      routeInformationParser: MyRouteInformationParser(),
    );
  }
}
