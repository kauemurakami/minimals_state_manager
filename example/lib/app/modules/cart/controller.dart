import 'package:example/app/data/models/item.dart';
import 'package:minimals_state_manager/app/state/min_notifier.dart';

class CartController extends MinNotifier {
  @override
  onInit() {
    print('cart controller init');
  }

  @override
  onReady() {
    print('cart controller ready');
  }

  List<Item> items = <Item>[];

  addItem(Item item) {
    try {
      bool? exists = items.any((i) => i.id == item.id);

      if (exists) {
        return true; // items contains item
      } else {
        update(items, (_) => _.add(item));
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
    update(items, (_) => _.removeWhere((element) => element == item));
    return true;
  }
}
