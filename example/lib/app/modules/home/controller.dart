import 'package:example/app/data/models/item.dart';
import 'package:example/app/data/providers/api.dart';
import 'package:example/app/modules/home/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:minimals_state_manager/app/state/min_notifier.dart';

class HomeController extends MinNotifier {
  final repository = HomeRepository(FakeApi());
  TextEditingController textController = TextEditingController();

  List<Item> items = <Item>[];
  int filter = 0;
  bool openned = true;

  @override
  onReady() {
    print('home controller init');
    scrollListener();
    getItems();
  }

  changeFilter(int type) {
    type >= 1 && type <= 3 ? filter = type : filter = 0;
    notifyListeners();
    filterItems(type);
  }

  filterItems(type) async {
    items = [];
    await getItems();
    items = items.where((item) => item.type == type).toList();
    notifyListeners();
  }

  removeFilters() async {
    items = [];
    filter = 0;
    await getItems();
  }

  getItems() async => await repository
      .getItems()
      .then((data) => update(items, (_) => _ = data));

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
    openned = false;
    notifyListeners();
  }

  showBottomNav() {
    openned = true;
    notifyListeners();
  }

  hideAppBar() {
    openned = false;
    notifyListeners();
  }

  showAppBar() {
    openned = true;
    notifyListeners();
  }
}
