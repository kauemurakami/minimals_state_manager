import 'package:example/app/data/models/item.dart';
import 'package:flutter/foundation.dart';
import 'package:minimals_state_manager/app/state_manager/extensions/min_listen.dart';
import 'package:minimals_state_manager/app/state_manager/extensions/min_update.dart';

class CartController extends ChangeNotifier {
  CartController() {
    print('cart controller init');
  }

  ValueNotifier<List<Item>> items = <Item>[].minx;
  // or final items = <Item>[].minx;

  addItem(Item item) {
    try {
      bool? exists = items.value.any((i) => i.id == item.id);

      if (exists) {
        return true; // items contains item
      } else {
        items.update((val) => val.add(item));
        // or
        // items.value.add(item);
        // items.notifyListeners();
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  removeItem(item) {
    items.update((val) => val.removeWhere((element) => element == item));
    return true;
  }
}
