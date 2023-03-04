import 'package:example/routes/app_page.dart';

abstract class RootRoutes {
  static final MyAppPage initial = MyAppPage(path: '/');
  static final MyAppPage login = MyAppPage(path: '/login');
  static final MyAppPage signup = MyAppPage(path: '/signup', isSubpage: true);
}

abstract class DashRoutes {
  static final MyAppPage home = MyAppPage(path: '/home');
  static final MyAppPage profile = MyAppPage(path: '/profile');
  static final MyAppPage other = MyAppPage(path: '/other');
}
