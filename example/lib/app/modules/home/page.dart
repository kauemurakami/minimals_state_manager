import 'package:example/app/data/models/item.dart';
import 'package:example/app/modules/cart/controller.dart';
import 'package:example/app/modules/cart/page.dart';
import 'package:example/app/modules/home/widgets/app_bar.dart';
import 'package:example/app/modules/home/widgets/drawer.dart';
import 'package:example/app/modules/home/widgets/fab.dart';
import 'package:example/app/modules/home/widgets/list_items.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      resizeToAvoidBottomInset: false,
      floatingActionButton: const FABWidget(),
      key: scaffoldKey,
      appBar: PreferredSize(
          preferredSize: Size(
            MediaQuery.of(context).size.width,
            50.0,
          ),
          child: HomeAppBar(
            scaffoldKey: scaffoldKey,
          )),
      endDrawer: HomeDrawer(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListItems(),
          ],
        ),
      ),
    );
  }
}
