import 'package:example/app/data/models/item.dart';

class Cart {
  List<Item>? items;
  double? totalValue;
  Cart({this.items, this.totalValue});
}
