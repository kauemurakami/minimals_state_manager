import 'package:example/app/data/models/item.dart';
import 'package:example/app/modules/home/controller.dart';
import 'package:example/app/modules/home/widgets/item.dart';
import 'package:flutter/material.dart';
import 'package:minimals_state_manager/app/extensions/min_provider_extensions.dart';
import 'package:minimals_state_manager/app/widgets/min_selector.dart';

class ListItems extends Container {
  ListItems({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<HomeController>();

    return Flexible(
      child: $<HomeController, List<Item>>(
        notifier: controller,
        selector: (notifier) => notifier.items,
        builder: (context, items) {
          if (items.isNotEmpty) {
            return ListView.builder(
                controller: controller.scrollController,
                itemCount: items.length,
                itemBuilder: (context, index) => ItemWidget(index));
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
