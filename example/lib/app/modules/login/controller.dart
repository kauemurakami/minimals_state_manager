import 'package:example/app/data/services/auth/service.dart';
import 'package:example/app/data/services/setup_locator.dart';
import 'package:example/app/modules/login/repository.dart';
import 'package:minimals_state_manager/min_notifiers.dart';

class LoginController extends MinNotifier {
  final LoginRepository repository = LoginRepository();
  final authService = min<AuthService>();
  bool loading = false;

  @override
  onInit() {
    print('LoginController init');
    super.onInit();
  }

  @override
  onReady() {
    print('LoginController ready');
    super.onReady();
  }

  login() async {
    loading = true;
    notifyListeners();
    await authService.login();
    loading = false;
    notifyListeners();
    return true;
  }

  onChangedName(_) => update(authService.user, (u) => u.name = _);
  validateName(_) =>
      authService.user.name == null || authService.user.name!.length < 2
          ? 'Insert valid name'
          : null;
  onSaveName(_) => update(authService.user, (u) => u.name = _);

  @override
  void dispose() {
    print('login controller dispose');
    super.dispose();
  }
}
