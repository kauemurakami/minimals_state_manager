import 'package:example/app/modules/cart/controller.dart';
import 'package:example/app/modules/dash/controller.dart';
import 'package:example/app/modules/dash/page.dart';
import 'package:example/app/modules/home/controller.dart';
import 'package:example/app/modules/home/page.dart';
import 'package:example/app/modules/profile/controller.dart';
import 'package:example/app/modules/profile/page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:minimals_state_manager/app/provider/min_multi_provider.dart';
import 'package:minimals_state_manager/app/provider/min_provider.dart';

void main() {
  runApp(MaterialApp.router(
      routerConfig: GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return MinProvider(controller: DashController(), child: DashPage());
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'home',
            builder: (BuildContext context, GoRouterState state) {
              return MinMultiProvider(
                  controllers: [MyController(), CartController()],
                  child: MyPage());
            },
          ),
          GoRoute(
            path: 'profile',
            builder: (BuildContext context, GoRouterState state) {
              return MinProvider(
                  controller: ProfileController(), child: const ProfilePage());
            },
          ),
        ],
      ),
    ],
  )));
}
