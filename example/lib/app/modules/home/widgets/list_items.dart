import 'package:example/app/modules/cart/controller.dart';
import 'package:example/app/modules/home/controller.dart';
import 'package:example/app/modules/home/functions/build_banner.dart';
import 'package:flutter/material.dart';
import 'package:minimals_state_manager/app/widgets/minx_widget.dart';
import 'package:minimals_state_manager/app/widgets/observable_widget.dart';

class ListItems extends Container {
  ListItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: MinX<HomeController>(
        builder: (context, controller) => $(
          controller.items,
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('${items[index].name} - $index'),
                          Text('Type ${items[index].type}'),
                          Text('${items[index].value}'),
                        ],
                      ),
                      MinX<CartController>(
                        builder: (context, cartController) => IconButton(
                          onPressed: () {
                            if (cartController.addItem(items[index])) {
                              ScaffoldMessenger.of(context).showMaterialBanner(
                                  buildBanner(context, error: false));
                            } else {
                              ScaffoldMessenger.of(context).showMaterialBanner(
                                  buildBanner(context, error: true));
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
        ),
      ),
    );
  }
}
