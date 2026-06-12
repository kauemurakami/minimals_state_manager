import 'package:example/app/data/models/item.dart';
import 'package:minimals_state_manager/app/state/min_notifier.dart';
import 'package:minimals_state_manager/app/observers/min_app_lifecycle.dart';

class CartController extends MinNotifier with AppLifecycleMixin {
  @override
  onInit() {
    print('cart controller init');
  }

  @override
  onReady() {
    print('cart controller ready');
  }

  List<Item> items = <Item>[];

  bool addItem(Item item) {
    bool exists = items.any((i) => i.id == item.id);

    if (exists) {
      return true;
    } else {
      update(items, (i) => items.add(item));
      return true;
    }
  }

  bool removeItem(item) {
    // items.removeWhere((element) => element == item);
    // items = List.of(items);
    // notifyListeners();
    update(items, (i) => items.removeWhere((element) => element == item));
    return true;
  }
}
