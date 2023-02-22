import 'package:example/app/modules/cart/controller.dart';
import 'package:example/app/modules/cart/page.dart';
import 'package:example/app/modules/home/widgets/app_bar.dart';
import 'package:example/app/modules/home/widgets/drawer.dart';
import 'package:example/app/modules/home/widgets/list_items.dart';
import 'package:flutter/material.dart';
import 'package:minimals_state_manager/app/widgets/minx_widget.dart';
import 'package:minimals_state_manager/app/widgets/observable_widget.dart';
// import 'package:minimals_state_manager/app/state_manager/widgets/page.dart';

class MyPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: MinX<CartController>(
        builder: (context, controller) => Stack(
          children: [
            FloatingActionButton(
              onPressed: () => showBottomSheet(
                enableDrag: true,
                context: context,
                builder: (context) => const CartPage(),
              ),
              backgroundColor: Colors.amber,
              //  Navigator.pushNamed(context, Routes.CART),
              child: const Icon(
                Icons.shopping_cart_checkout_outlined,
              ),
            ),
            $(
              (items) => items.isEmpty
                  ? const SizedBox.shrink()
                  : Positioned(
                      right: .0,
                      top: .0,
                      child: Container(
                        height: 16.0,
                        width: 16.0,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.greenAccent),
                        child: Center(
                          child: Text(
                            '${items.length}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )),
              listener: controller.items,
            )
          ],
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
