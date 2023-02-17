import 'package:example/app/data/models/item.dart';
import 'package:flutter/foundation.dart';
import 'package:minimals_state_manager/app/state_manager/controller/min_controller.dart';
import 'package:minimals_state_manager/app/state_manager/extensions/min_listen.dart';

class CartController extends MinController {
  @override
  void onInit() {
    print('cart controller');
    super.onInit();
  }

  ValueNotifier<List<Item>> items = <Item>[].minx;

  addItem(Item item) {
    try {
      bool? exists = items.value.any((item) => item.id == item.id);

      if (exists) {
        return true; // items contains item
      } else {
        items.value.add(item);
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  removeItem(item) {
    items.value.removeWhere((element) => element == item);
    return true;
  }
}
