import 'package:example/app/data/models/item.dart';
import 'package:minimals_state_manager/app/state/min_notifier.dart';
import 'package:minimals_state_manager/app/state/mixins/min_app_lifecycle.dart';

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
      items.add(item);
      notifyListeners();
      return true;
    }
  }

  bool removeItem(item) {
    items.removeWhere((element) => element == item);
    notifyListeners();
    return true;
  }
}
