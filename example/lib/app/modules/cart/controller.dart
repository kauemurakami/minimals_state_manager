import 'package:example/app/data/models/cart.dart';
import 'package:minimals_state_manager/app/state_manager/controller/min_controller.dart';
import 'package:minimals_state_manager/app/state_manager/extensions/min_listen.dart';

class CartController extends MinController {
  final items = Cart().minx;

  @override
  void onInit() {
    print('cart controller');
    super.onInit();
  }

  addItem() {}
  removeItem() {}

  final count = 0.minx;
  // final user = User().minx;

  increment() => count.value++;
  decrement() => count.value--;

  // onChangedName(_) => user.update((val) => val.name = _);
  // validateName(_) => null;
  // onSavedName(_) => user.update((val) => val.name = _);
  // onChangedEmail(_) => user.update((val) => val.email = _);
  // validateEmail(_) => null;
  // onSavedEmail(_) => user.update((val) => val.email = _);
}
