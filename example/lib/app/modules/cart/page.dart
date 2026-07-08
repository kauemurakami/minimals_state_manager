import 'package:example/app/data/models/item.dart';
import 'package:example/routes/delegate_imports.dart';
import 'package:flutter/material.dart';
import 'package:minimals_state_manager/min_extensions.dart';
import 'package:minimals_state_manager/min_widgets.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final controller = MinMultiProvider.read<CartController>(context);
    // or
    final controller = context.read<CartController>();

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: $<CartController, List<Item>>(
                notifier: controller,
                selector: (notifier) => notifier.items,
                builder: (context, items) => items.isEmpty
                    ? const Center(
                        child: Text('Cart is empty'),
                      )
                    : ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) => Container(
                          margin: const EdgeInsets.all(6.0),
                          height: 100.0,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: const BorderRadius.all(
                              Radius.circular(6.0),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox.shrink(),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text('${items[index].name} - $index'),
                                  Text(items[index].type.name),
                                  Text('R\$ ${items[index].value}'),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  controller.removeItem(items[index]);
                                },
                                icon: const Icon(
                                  Icons.remove,
                                  color: Colors.red,
                                  size: 24.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
            MaterialButton(
              color: Colors.red,
              onPressed: () {
                context.pop();
              },
              child: const Text('CLOSE'),
            )
          ],
        ),
      ),
    );
  }
}
