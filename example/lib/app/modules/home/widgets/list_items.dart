import 'package:example/app/modules/home/controller.dart';
import 'package:example/app/modules/home/widgets/item.dart';
import 'package:flutter/material.dart';
import 'package:minimals_state_manager/app/provider/min_provider.dart';
import 'package:minimals_state_manager/app/widgets/observable_widget.dart';

class ListItems extends Container {
  ListItems({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MinProvider.use<HomeController>(context);

    return Flexible(
      child: $(
        controller.items,
        (items) {
          if (items.isNotEmpty) {
            return ListView.builder(
                controller: controller.scrollController,
                itemCount: items.length,
                itemBuilder: (context, index) => Item(index));
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.amber,
              ),
            );
          }
        },
      ),
    );
  }
}
