import 'package:minimals_state_manager/app/state_manager/controller/min_controller.dart';
import 'package:minimals_state_manager/app/state_manager/extensions/min_listen.dart';

class MyController2 extends MinController {
  final countFloat = 0.0.minx;

  @override
  onInit() {
    print('ola');
  }

  // final text = 'abc'.minx;
  // changeText() => text.value == 'abc' ? text.value = 'def' : text.value = 'abc';
}
