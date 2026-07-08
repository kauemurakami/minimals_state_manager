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

  void addItem(Item item) {
    bool exists = items.any((i) => i.id == item.id);

    if (exists) {
    } else {
      items.add(item);
      notifyListeners();
    }
  }

  void removeItem(item) {
    items.removeWhere((element) => element == item);
    notifyListeners();
  }
}
