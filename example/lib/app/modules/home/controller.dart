import 'package:example/app/data/models/item.dart';
import 'package:example/app/data/providers/api.dart';
import 'package:example/app/modules/home/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:minimals_state_manager/app/state_manager/extensions/min_listen.dart';

class HomeController extends ChangeNotifier {
  final repository = HomeRepository(FakeApi());
  TextEditingController textController = TextEditingController();

  ValueNotifier<List<Item>> items = <Item>[].minx;
  ValueNotifier<int> filter = 0.minx;
  ValueNotifier<bool> openned = true.minx;
  /*
  or it can also be declared final
  final items = <Item>[].minx; -> ValueNotifier<List<Item>> 
  final filter = 0.minx;       -> ValueNotifier<int>
  final openned = true.minx;   ->  ValueNotifier<bool>
  */

  HomeController() {
    print('home controller init');
    scrollListener();
    getItems();
  }

  changeFilter(int type) {
    type >= 1 && type <= 3 ? filter.value = type : filter.value = 0;
    filterItems(type);
  }

  filterItems(type) async {
    items.value = [];
    await getItems();
    items.value = items.value.where((item) => item.type == type).toList();
  }

  removeFilters() async {
    items.value = [];
    filter.value = 0;
    await getItems();
  }

  getItems() async =>
      await repository.getItems().then((data) => items.value = data);

  //remover scrol controller no dispose
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
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
