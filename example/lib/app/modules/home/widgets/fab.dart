import 'package:example/app/data/models/item.dart';
import 'package:example/app/modules/cart/controller.dart';
import 'package:example/app/modules/cart/page.dart';
import 'package:flutter/material.dart';
import 'package:minimals_state_manager/min_providers.dart';
import 'package:minimals_state_manager/min_widgets.dart';

class FABWidget extends StatelessWidget {
  const FABWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = MinMultiProvider.read<CartController>(context);

    return Stack(
      children: [
        FloatingActionButton(
          onPressed: () => showModalBottomSheet(
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
        Positioned(
          right: .0,
          top: .0,
          child: $<CartController, List<Item>>(
              notifier: cartController,
              selector: (notifier) => notifier.items,
              builder: (context, items) => items.isEmpty
                  ? const SizedBox.shrink()
                  : Container(
                      height: 20.0,
                      width: 20.0,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.green),
                      child: Center(
                        child: Text(
                          '${items.length}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    )),
        )
      ],
    );
  }
}
