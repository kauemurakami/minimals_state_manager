import 'package:example/app/data/models/item.dart';
import 'package:example/app/modules/cart/controller.dart';
import 'package:example/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:minimals_state_manager/min_extensions.dart';
import 'package:minimals_state_manager/min_providers.dart';
import 'package:minimals_state_manager/min_widgets.dart';

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
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(4.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox.shrink(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('${items[index].name} - $index'),
                Text(items[index].type.name),
                Text('R\$ ${items[index].value}'),
              ],
            ),
            IconButton(
              onPressed: () {
                cartController.addItem(items[index]);
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
