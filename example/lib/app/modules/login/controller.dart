import 'package:example/app/data/models/user.dart';
import 'package:example/app/modules/login/repository.dart';
import 'package:flutter/widgets.dart';
import 'package:minimals_state_manager/app/state_manager/extensions/min_listen.dart';
import 'package:minimals_state_manager/app/state_manager/extensions/min_update.dart';

class LoginController extends ChangeNotifier {
  final LoginRepository repository = LoginRepository();
  final user = User().minx;
  final loading = false.minx;

  login() async {
    loading.value = true;
    await Future.delayed(
      const Duration(seconds: 2),
      () => loading.value = false,
    );
    return true;
  }

  onChangedName(_) => user.update((u) => u.name = _);
  validateName(_) => user.value.name == null || user.value.name!.length < 2
      ? 'Insert valid name'
      : null;
  onSaveName(_) => user.update((u) => u.name = _);
}
