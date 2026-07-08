import 'package:example/app/data/enums/item_type.dart';
import 'package:example/app/data/models/item.dart';

class FakeApi {
  getItems() async {
    final List<Item> items = await Future.delayed(
      const Duration(seconds: 2),
    ).then((value) => <Item>[
          Item(name: 'Item', value: 10, type: ItemType.A, id: 124),
          Item(name: 'Item', value: 24, type: ItemType.B, id: 325),
          Item(name: 'Item', value: 1, type: ItemType.A, id: 646),
          Item(name: 'Item', value: 19, type: ItemType.C, id: 426),
          Item(name: 'Item', value: 15, type: ItemType.A, id: 976),
          Item(name: 'Item', value: 22, type: ItemType.B, id: 512),
          Item(name: 'Item', value: 73, type: ItemType.C, id: 627),
          Item(name: 'Item', value: 12, type: ItemType.A, id: 028),
          Item(name: 'Item', value: 244, type: ItemType.C, id: 209),
          Item(name: 'Item', value: 37, type: ItemType.B, id: 100),
          Item(name: 'Item', value: 100, type: ItemType.C, id: 412),
        ]);
    return items;
  }
}
