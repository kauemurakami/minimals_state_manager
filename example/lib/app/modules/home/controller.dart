import 'package:example/app/data/models/item.dart';
import 'package:example/app/data/providers/api.dart';
import 'package:example/app/modules/home/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:minimals_state_manager/app/state_manager/controller/min_controller.dart';
import 'package:minimals_state_manager/app/state_manager/extensions/min_listen.dart';

class HomeController extends MinController {
  final repository = HomeRepository(FakeApi());
  ValueNotifier<bool> openned = true.minx;
  TextEditingController textController = TextEditingController();

  ValueNotifier<List<Item>> items = <Item>[].minx;
  ValueNotifier<int> filter = 0.minx;
  @override
  onInit() async {
    print('home controller');
    await getItems();
  }

  changeFilter(int type) {
    type >= 1 && type <= 3 ? filter.value = type : filter.value = 0;
    filterItems(type);
  }

  filterItems(type) {
    items.value = items.value.where((item) => item.type == type).toList();
  }

  removeFilters() async {
    filter.value = 0;
    await getItems();
  }

  getItems() async =>
      await repository.getItems().then((data) => items!.value = data);

  //remover scrol controller no dispose
  ScrollController scrollController = ScrollController();
  // HomeController() {
  //   scrollListener();
  // }

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

  hideBottomNav() {
    openned.value = false;
  }

  showBottomNav() {
    openned.value = true;
  }

  hideAppBar() => openned.value = false;
  showAppBar() => openned.value = true;
}
