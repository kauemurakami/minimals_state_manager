import 'package:example/routes/page.dart';
import 'package:flutter/material.dart';

class MyRouterDelegate extends RouterDelegate<Uri>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final List<AppPage>? pages;
  late List<Page> _navigatorPages;
  MyRouterDelegate({required this.pages}) {
    if (pages == null) {
      throw Exception('pages cannot be null');
    }
    final initial = pages!.firstWhere((page) => page.path == '/');
    _navigatorPages = [MaterialPage(name: '/', child: initial.builder({}))];
  }

  @override
  Widget build(BuildContext context) => Navigator(
      pages: _navigatorPages,
      onPopPage: (route, result) => route.didPop(result));

  @override
  Future<void> setNewRoutePath(Uri configuration) async {
    final path = configuration.path;
    final data = <String, String>{};
    final index = pages!.indexWhere((page) {
      if (page.path == path) {
        return true;
      }
      if (page.path!.contains('/:')) {
        // contains parameters
        final lastIndex = page.path!.lastIndexOf('/:');
        final substring = page.path!.substring(
          0,
          lastIndex,
        );
        if (path.startsWith(substring)) {
          final key = page.path!.substring(lastIndex + 2, page.path!.length);
          final value = path.substring(lastIndex + 1, path.length);
          data[key] = value;
          return true;
        }
      }
      return false;
    });
    print(configuration.path);
    print(configuration.queryParameters);
    if (index != -1) {
      _navigatorPages = [
        ..._navigatorPages,
        MaterialPage(
          child: pages![index].builder(data),
        ),
      ];
      _navigatorPages.add(MaterialPage(
        child: pages![index].builder(data),
      ));
      notifyListeners();
    }
  }

  @override
  // TODO: implement navigatorKey
  GlobalKey<NavigatorState>? get navigatorKey => GlobalKey<NavigatorState>();
}
