import 'package:example/app/data/models/cart.dart';
import 'package:minimals_state_manager/app/state_manager/controller/min_controller.dart';
import 'package:minimals_state_manager/app/state_manager/extensions/min_listen.dart';

class CartController extends MinController {
  final items = Cart().minx;
}
