const _typeA = 'TYPEA';
const _typeB = 'TYPEB';
const _typeC = 'TYPEC';
const _empty = 'EMPTY';

enum ItemType {
  A(_typeA, 'Tipo A'),
  B(_typeB, 'Tipo B'),
  C(_typeC, 'Tipo C'),
  empty(_empty, 'EMPTY');

  const ItemType(this._value, this._name);

  static final validTypes = [
    ItemType.A,
    ItemType.B,
    ItemType.C,
  ];

  final String _value;
  String get value => _value;

  final String _name;
  String get name => _name;
}
