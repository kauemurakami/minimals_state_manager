import 'package:example/app/data/models/item.dart';
import 'package:example/app/modules/cart/controller.dart';
import 'package:example/app/modules/home/controller.dart';
import 'package:example/app/modules/widgets/build_banner.dart';
import 'package:flutter/material.dart';
import 'package:minimals_state_manager/app/extensions/min_provider_extensions.dart';
import 'package:minimals_state_manager/app/provider/min_multi_provider.dart';
import 'package:minimals_state_manager/app/widgets/min_selector.dart';

class ItemWidget extends Container {
  ItemWidget(this.index, {super.key});
  final int index;
  @override
  Widget build(BuildContext context) {
    final controller = context.read<HomeController>();
    final cartController = MinMultiProvider.read<CartController>(context);

    return $<HomeController, List<Item>>(
      notifier: controller,
      selector: (notifier) => notifier.items,
      builder: (context, items) => Container(
        margin: const EdgeInsets.all(6.0),
        height: 100.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(.5),
            borderRadius: const BorderRadius.all(Radius.circular(4.0))),
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
            IconButton(
              onPressed: () {
                if (cartController.addItem(items[index])) {
                  ScaffoldMessenger.of(context).showMaterialBanner(buildBanner(
                      context,
                      message: 'Add item to cart',
                      isRemoved: false));
                }
              },
              icon: const Icon(
                Icons.add,
                color: Colors.green,
                size: 24.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
