import 'package:example/routes/delegate_imports.dart';
import 'package:example/routes/providers.dart';

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
          print('initial login ${state.fullPath}');
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
              print('going signup ${state.fullPath}');
              return CustomFadeTransition(
                child: MinProvider(
                  controller: SignupController(),
                  child: const SignupPage(),
                ),
              );
            },
          ),
        ],
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        pageBuilder: (context, state, child) {
          print('shell direction ${state.fullPath}');
          return CustomFadeTransition(
            child: MinMultiProvider(
              controllers: [
                dashController,
                cartController,
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
              print(' ${state.fullPath}');
              return CustomSlideTransition(
                from: SlideFrom.left,
                key: state.pageKey,
                child: MinProvider(
                  controller: HomeController(),
                  child: HomePage(),
                ),
              );
            },
          ),
          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            name: 'profile',
            path: '/profile',
            pageBuilder: (BuildContext context, GoRouterState state) {
              print(' ${state.fullPath}');
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
              print(' ${state.fullPath}');
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
