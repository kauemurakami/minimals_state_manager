import 'package:example/app/modules/cart/controller.dart';
import 'package:example/app/modules/home/controller.dart';
import 'package:example/app/modules/home/widgets/app_bar.dart';
import 'package:example/app/modules/home/widgets/banner.dart';
import 'package:example/app/modules/home/widgets/drawer.dart';
import 'package:example/routes/pages.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, Routes.CART),
        child: const Icon(Icons.shopping_cart_checkout_outlined),
      ),
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 50.0),
          child: HomeAppBar(
            scaffoldKey: scaffoldKey,
          )),
      endDrawer: const HomeDrawer(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: MinX<HomeController>(
                builder: (context, controller) => $(
                  (items) {
                    if (items.isNotEmpty) {
                      return ListView.builder(
                        controller: controller.scrollController,
                        itemCount: items.length,
                        itemBuilder: (context, index) => Container(
                          margin: const EdgeInsets.all(6.0),
                          height: 100.0,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(.5),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4.0))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox.shrink(),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text('${items[index].name} - $index'),
                                  Text('Type ${items[index].type}'),
                                  Text('${items[index].value}'),
                                ],
                              ),
                              MinX<CartController>(
                                builder: (context, cartController) =>
                                    IconButton(
                                  onPressed: () {
                                    if (cartController.addItem(items[index])) {
                                      ScaffoldMessenger.of(context)
                                          .showMaterialBanner(buildBanner(
                                              context,
                                              error: false));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showMaterialBanner(buildBanner(
                                              context,
                                              error: true));
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.green,
                                    size: 24.0,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.amber,
                        ),
                      );
                    }
                  },
                  listener: controller.items,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  buildBanner(context, {error}) {
    return MaterialBanner(
        backgroundColor: Colors.amber,
        content: Text(
          error ? 'item removed to cart' : 'item added to cart',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () =>
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
            child: const Text(
              'OK',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500),
            ),
          )
        ]);
  }
}
