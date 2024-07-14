import 'package:example/app/modules/cart/controller.dart';
import 'package:example/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:minimals_state_manager/app/provider/min_multi_provider.dart';
import 'package:minimals_state_manager/app/provider/min_provider.dart';
import 'package:minimals_state_manager/app/widgets/observable_widget.dart';

class Item extends Container {
  Item(this.index, {super.key});
  final int index;
  @override
  Widget build(BuildContext context) {
    final controller = MinProvider.use<HomeController>(context);
    final cartController = MinMultiProvider.use<CartController>(context);

    return $(
      controller.items,
      (items) => Container(
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
              onPressed: () => cartController.addItem(
                items[index],
              ),
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
