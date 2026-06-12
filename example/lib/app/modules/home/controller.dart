import 'package:example/app/data/models/item.dart';
import 'package:example/app/data/providers/api.dart';
import 'package:example/app/modules/home/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:minimals_state_manager/app/state/min_notifier.dart';

class HomeController extends MinNotifier with WidgetsBindingObserver {
  final repository = HomeRepository(FakeApi());
  TextEditingController textController = TextEditingController();

  List<Item> items = <Item>[];
  int filter = 0;
  bool openned = true;

  @override
  void update<K>(K target, void Function(K) action) {
    // TODO: implement update
    super.update(target, action);
  }

  @override
  void onInit() {
    super.onInit();
    print('home controller init');
    scrollListener();
    getItems();
  }

  @override
  onReady() {
    print('home controller rendered');
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

  Future<void> getItems() async {
    items = await repository.getItems();
    notifyListeners();
  }

  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    print('home controller dispose');
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
