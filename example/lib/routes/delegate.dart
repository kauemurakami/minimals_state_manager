import 'package:example/routes/delegate_imports.dart';

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
          debugPrint('initial login ${state.fullPath}');
          return CustomFadeTransition(
            child: MinProvider<LoginController>(
              create: () => LoginController(),
              child: LoginPage(),
            ),
          );
        },
        routes: <RouteBase>[
          GoRoute(
            name: 'signup',
            path: 'signup',
            pageBuilder: (BuildContext context, GoRouterState state) {
              debugPrint('going signup ${state.fullPath}');
              return CustomFadeTransition(
                child: MinProvider<SignupController>(
                  create: () => SignupController(),
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
          debugPrint('shell direction ${state.fullPath}');
          return CustomFadeTransition(
            child: MinMultiProvider(
              create: [
                () => DashController(),
                () => CartController(),
              ],
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
              debugPrint(' ${state.fullPath}');
              return CustomSlideTransition(
                from: SlideFrom.left,
                key: state.pageKey,
                child: MinProvider<HomeController>(
                  key: ValueKey('min_provider_home_${state.pageKey}'),
                  create: () => HomeController(),
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
              debugPrint(' ${state.fullPath}');
              return CustomVerticalTransition(
                key: state.pageKey,
                child: MinProvider<ProfileController>(
                  create: () => ProfileController(),
                  child: ProfilePage(),
                ),
              );
            },
          ),
          GoRoute(
            name: 'other',
            path: '/other',
            pageBuilder: (BuildContext context, GoRouterState state) {
              debugPrint(' ${state.fullPath}');
              return CustomSlideTransition(
                from: SlideFrom.right,
                key: state.pageKey,
                child: MinProvider<OtherController>(
                  create: () => OtherController(),
                  child: const OtherPage(),
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
