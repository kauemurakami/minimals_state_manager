import 'package:example/app/data/models/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:minimals_state_manager/app/state_manager/controller/min_controller.dart';
import 'package:minimals_state_manager/app/state_manager/extensions/min_listen.dart';

class HomeController extends MinController {
  ValueNotifier<bool> openned = true.minx;
  TextEditingController textController = TextEditingController();
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
  ScrollController scrollController = ScrollController();
  HomeController() {
    scrollListener();
  }
  onABC() {
    print('iniciou');
  }

  double getHeight(context) {
    return 0.0;
  }

  scrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        hideAppBar();
      }
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        showAppBar();
      }
    });
  }

  hideAppBar() => openned.value = false;
  showAppBar() => openned.value = true;
  // @override
  // onInit() async {
  //   // await Future.delayed(const Duration(seconds: 5));
  //   print('home controller');
  // }
}
