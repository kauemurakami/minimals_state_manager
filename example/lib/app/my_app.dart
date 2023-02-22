import 'package:example/app/modules/dash/controller.dart';
import 'package:example/app/modules/dash/page.dart';
import 'package:example/routes/delegate.dart';
import 'package:example/routes/page.dart';
import 'package:example/routes/pages.dart';
import 'package:example/routes/route_information_parser.dart';
import 'package:flutter/material.dart';
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
        path: Routes.DASH),
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
