import 'package:example/app/data/enums/item_type.dart';

class Item {
  String? name;
  int? id;
  ItemType type;
  double? value;
  Item({this.name, this.value, required this.type, this.id});
}
