import 'package:example/app/data/models/item.dart';
import 'package:minimals_state_manager/app/state_manager/controller/min_controller.dart';
import 'package:minimals_state_manager/app/state_manager/extensions/min_listen.dart';

class MyController extends MinController {
  final items = <Item>[
    Item(name: 'Item', value: 10),
    Item(name: 'Item', value: 12),
    Item(name: 'Item', value: 1),
    Item(name: 'Item', value: 15),
    Item(name: 'Item', value: 22),
    Item(name: 'Item', value: 37),
    Item(name: 'Item', value: 73),
    Item(name: 'Item', value: 19),
    Item(name: 'Item', value: 244),
    Item(name: 'Item', value: 24),
    Item(name: 'Item', value: 100),
  ].minx;
  @override
  onInit() async {
    await Future.delayed(const Duration(seconds: 5));
    print('ola controller 1');
  }
}
