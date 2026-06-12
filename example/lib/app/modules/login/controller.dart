import 'package:example/app/data/models/user.dart';
import 'package:example/app/modules/login/repository.dart';
import 'package:minimals_state_manager/app/state/min_notifier.dart';

class LoginController extends MinNotifier {
  final LoginRepository repository = LoginRepository();
  final user = User();
  bool loading = false;

  login() async {
    update(user, (u) => u.name = 'Kauê');

    loading = true;
    notifyListeners();
    await Future.delayed(
      const Duration(seconds: 2),
      () => loading = false,
    );
    notifyListeners();
    return true;
  }

  onChangedName(_) => update(user, (u) => u.name = _);
  validateName(_) =>
      user.name == null || user.name!.length < 2 ? 'Insert valid name' : null;
  onSaveName(_) => update(user, (u) => u.name = _);

  @override
  void dispose() {
    print('login controller dispose');
    super.dispose();
  }
}
