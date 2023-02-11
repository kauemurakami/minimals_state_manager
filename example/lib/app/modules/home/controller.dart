import 'package:example/app/data/models/user.dart';
import 'package:minimals_state_manager/app/state_manager/controller/min_controller.dart';
import 'package:minimals_state_manager/app/state_manager/extensions/min_listen.dart';

class MyController extends MinController {
  final count = 0.minx;
  final user = User().minx;

  @override
  onInit() {
    print('ola');
  }

  increment() => count.value++;
  decrement() => count.value--;

  onChangedName(_) => user.value.name = _;
  validateName(_) => null;
  onSavedName(_) => user.value.name = _;
  onChangedEmail(_) => user.value.email = _;
  validateEmail(_) => null;
  onSavedEmail(_) => user.value.email = _;
}
