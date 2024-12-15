import 'package:example/app/data/enums/item_type.dart';

extension TranslateItemType on ItemType {
  String get translate => this == ItemType.typeA
      ? 'Type A'
      : this == ItemType.typeB
          ? 'Type B'
          : 'Type C';
}
