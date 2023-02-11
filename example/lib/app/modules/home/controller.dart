import 'package:example/app/data/models/user.dart';
import 'package:minimals_state_manager/app/state_manager/controller/min_controller.dart';
import 'package:minimals_state_manager/app/state_manager/extensions/min_listen.dart';
import 'package:minimals_state_manager/app/state_manager/extensions/min_update.dart';

class MyController extends MinController {
  final count = 0.minx;
  final user = User().minx;

  @override
  onInit() {
    print('ola');
  }

  increment() => count.value++;
  decrement() => count.value--;

  onChangedName(_) => user.update((val) => val.name = _);
  validateName(_) => null;
  onSavedName(_) => user.update((val) => val.name = _);
  onChangedEmail(_) => user.update((val) => val.email = _);
  validateEmail(_) => null;
  onSavedEmail(_) => user.update((val) => val.email = _);
}
