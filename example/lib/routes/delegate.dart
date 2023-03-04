import 'package:example/app/core/utils/navigation/transitions/fade_transition.dart';
import 'package:example/app/core/utils/navigation/transitions/slide_from.dart';
import 'package:example/app/core/utils/navigation/transitions/slide_transition.dart';
import 'package:example/app/core/utils/navigation/transitions/vertical_transition.dart';
import 'package:example/app/modules/cart/controller.dart';
import 'package:example/app/modules/dash/controller.dart';
import 'package:example/app/modules/dash/page.dart';
import 'package:example/app/modules/home/controller.dart';
import 'package:example/app/modules/home/page.dart';
import 'package:example/app/modules/login/controller.dart';
import 'package:example/app/modules/login/page.dart';
import 'package:example/app/modules/other_module/controller.dart';
import 'package:example/app/modules/other_module/page.dart';
import 'package:example/app/modules/profile/controller.dart';
import 'package:example/app/modules/profile/page.dart';
import 'package:example/app/modules/signup/controller.dart';
import 'package:example/app/modules/signup/page.dart';
import 'package:example/routes/routes.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:minimals_state_manager/app/provider/min_multi_provider.dart';
import 'package:minimals_state_manager/app/provider/min_provider.dart';
import 'package:minimals_state_manager/app/state_manager/controller/permament_controller.dart';

abstract class GoRootDelegate {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    navigatorKey: _rootNavigatorKey,
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        redirect: (context, state) => '/login',
      ),
      GoRoute(
        name: 'login',
        path: '/login',
        pageBuilder: (BuildContext context, GoRouterState state) {
          print('initial login ${state.location}' ?? '');
          return CustomFadeTransition(
            child: MinProvider(
              controller: LoginController(),
              child: LoginPage(),
            ),
          );
        },
        routes: <RouteBase>[
          GoRoute(
            name: 'signup',
            path: 'signup',
            pageBuilder: (BuildContext context, GoRouterState state) {
              print('going signup ${state.location}' ?? '');
              return CustomFadeTransition(
                child: MinProvider(
                  controller: SignupController(),
                  child: SignupPage(),
                ),
              );
            },
          ),
        ],
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        pageBuilder: (context, state, child) {
          print('shell direction ${state.location}');
          return CustomFadeTransition(
            child: MinMultiProvider(
              controllers: [
                MinService.permanentController(
                  DashController(),
                ),
                MinService.permanentController(
                  CartController(),
                ),
              ],
              // child:MinProvider(
              //   controller: ,
              child: DashPage(child: child),
            ),
          );
        },
        routes: <RouteBase>[
          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            name: 'home',
            path: '/home',
            pageBuilder: (BuildContext context, GoRouterState state) {
              print('a3 ${state.location}' ?? '');
              return CustomSlideTransition(
                from: SlideFrom.left,
                key: state.pageKey,
                child: MinProvider(
                  controller: HomeController(),
                  child: HomePage(),
                ),
              );
            },
            // routes: <RouteBase>[
            //   GoRoute(
            //       name: 'establishment',
            //       path: ':id',
            //       builder: (BuildContext context, GoRouterState state) {
            //         print('a3-1 ${state.location}' ?? '');

            //         return MinProvider(
            //           controller: EstablishmentController(),
            //           child: EstablishmentPage(),
            //         );
            //       })
            // ],
          ),
          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            name: 'profile',
            path: '/profile',
            pageBuilder: (BuildContext context, GoRouterState state) {
              print('a4 ${state.location}' ?? '');
              return CustomVerticalTransition(
                key: state.pageKey,
                child: MinProvider(
                  controller: ProfileController(),
                  child: const ProfilePage(),
                ),
              );
            },
          ),
          GoRoute(
            name: 'other',
            path: '/other',
            // name: DashRoutes.other.name,
            // path: DashRoutes.other.path,

            pageBuilder: (BuildContext context, GoRouterState state) {
              print('a4 ${state.location}' ?? '');
              return CustomSlideTransition(
                from: SlideFrom.right,
                key: state.pageKey,
                child: MinProvider(
                  controller: OtherController(),
                  child: OtherPage(),
                ),
              );
            },
          ),
        ],
      ),
    ],
    debugLogDiagnostics: true,
  );
}
