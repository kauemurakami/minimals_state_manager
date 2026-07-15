import 'package:example/app/data/enums/item_type.dart';
import 'package:example/app/data/models/item.dart';
import 'package:example/app/data/providers/api.dart';
import 'package:example/app/modules/home/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:minimals_state_manager/min_notifiers.dart';

class HomeController extends MinNotifier with WidgetsBindingObserver {
  final repository = HomeRepository(FakeApi());
  TextEditingController textController = TextEditingController();

  List<Item> items = <Item>[];
  ItemType filter = ItemType.empty;
  bool openned = true;

  @override
  void onInit() {
    super.onInit();
    debugPrint('home controller init');
    scrollListener();
    getItems();
  }

  @override
  onReady() {
    debugPrint('home controller rendered');
  }

  changeFilter(ItemType type) {
    filter = type;
    notifyListeners();
    filterItems(type);
  }

  filterItems(ItemType type) async {
    items = [];
    await getItems();
    items = items.where((item) => item.type == type).toList();
    notifyListeners();
  }

  removeFilters() async {
    items = [];
    notifyListeners();
    filter = ItemType.empty;
    await getItems();
  }

  Future<void> getItems() async {
    items = await repository.getItems();
    notifyListeners();
  }

  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    debugPrint('home controller dispose');
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

  hideAppBar() {
    openned = false;
    notifyListeners();
  }

  showAppBar() {
    openned = true;
    notifyListeners();
  }
}
