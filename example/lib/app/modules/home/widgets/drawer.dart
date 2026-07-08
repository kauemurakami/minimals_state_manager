import 'package:example/app/data/services/auth/service.dart';
import 'package:example/app/data/services/setup_locator.dart';
import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  HomeDrawer({super.key});
  final AuthService _authService = min.get<AuthService>();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              _authService.user.name!,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
            title: const Text('Item 1'),
            onTap: () {
              // ação do item 1
            },
          ),
          ListTile(
            title: const Text('Item 2'),
            onTap: () {
              // ação do item 2
            },
          ),
        ],
      ),
    );
  }
}
