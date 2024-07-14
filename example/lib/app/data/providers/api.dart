import 'package:example/app/data/models/item.dart';

class FakeApi {
  getItems() async {
    final List<Item> items = await Future.delayed(
      const Duration(seconds: 2),
    ).then((value) => <Item>[
          Item(name: 'Item', value: 10, type: 1, id: 124),
          Item(name: 'Item', value: 24, type: 3, id: 325),
          Item(name: 'Item', value: 1, type: 1, id: 646),
          Item(name: 'Item', value: 19, type: 3, id: 426),
          Item(name: 'Item', value: 15, type: 1, id: 976),
          Item(name: 'Item', value: 22, type: 2, id: 512),
          Item(name: 'Item', value: 73, type: 3, id: 627),
          Item(name: 'Item', value: 12, type: 1, id: 028),
          Item(name: 'Item', value: 244, type: 3, id: 209),
          Item(name: 'Item', value: 37, type: 2, id: 100),
          Item(name: 'Item', value: 100, type: 3, id: 412),
        ]);
    return items;
  }
}
