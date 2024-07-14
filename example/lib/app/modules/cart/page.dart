import 'package:example/app/modules/cart/controller.dart';
import 'package:flutter/material.dart';
import 'package:minimals_state_manager/app/provider/min_multi_provider.dart';
import 'package:minimals_state_manager/app/widgets/observable_widget.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MinMultiProvider.use<CartController>(context);

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: $(
                controller.items,
                (items) => items.isEmpty
                    ? const Center(
                        child: Text('Cart is empty'),
                      )
                    : ListView.builder(
                        itemCount: controller.items.value.length,
                        itemBuilder: (context, index) => Container(
                          margin: const EdgeInsets.all(6.0),
                          height: 100.0,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(.5),
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
                                  Text('Type ${items[index].type}'),
                                  Text('${items[index].value}'),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  if (controller.removeItem(items[index])) {
                                    // ScaffoldMessenger.of(context)
                                    //     .showMaterialBanner(
                                    //   buildBanner(
                                    //     context, error:true
                                    //   ),
                                    // );
                                  }
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
              onPressed: () => Navigator.pop(context),
              child: const Text('CLOSE'),
            )
          ],
        ),
      ),
    );
  }
}
