import 'package:example/app/modules/cart/page.dart';
import 'package:example/app/modules/home/widgets/app_bar.dart';
import 'package:example/app/modules/home/widgets/drawer.dart';
import 'package:example/app/modules/home/widgets/list_items.dart';
import 'package:flutter/material.dart';
// import 'package:minimals_state_manager/app/state_manager/widgets/page.dart';

class MyPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => showBottomSheet(
          context: context,
          builder: (context) => const CartPage(),
        ),
        backgroundColor: Colors.amber,
        //  Navigator.pushNamed(context, Routes.CART),
        child: const Icon(
          Icons.shopping_cart_checkout_outlined,
        ),
      ),
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          preferredSize: Size(
            MediaQuery.of(context).size.width,
            50.0,
          ),
          child: HomeAppBar(
            scaffoldKey: scaffoldKey,
          )),
      endDrawer: const HomeDrawer(),
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
