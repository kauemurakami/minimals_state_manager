import 'package:example/app/data/enums/item_type.dart';
import 'package:example/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:minimals_state_manager/app/widgets/min_selector.dart';

class BSFilters extends StatelessWidget {
  const BSFilters({super.key, required this.controller});
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(6.0),
        ),
      ),
      height: MediaQuery.of(context).size.height / 2.5,
      child: Column(
        children: [
          const Flexible(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Filtros',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
              ),
            ],
          )),
          Flexible(
            flex: 4,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: $<HomeController, ItemType>(
                notifier: controller,
                selector: (notifier) => notifier.filter,
                builder: (context, filter) => ListView.builder(
                  itemCount: ItemType.validTypes.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () =>
                        controller.changeFilter(ItemType.validTypes[index]),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      height: MediaQuery.of(context).size.height * 0.06,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: filter != ItemType.EMPTY &&
                                    (ItemType.validTypes[index] == filter)
                                ? Colors.green
                                : Colors.amber),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(6.0),
                        ),
                      ),
                      child:
                          Center(child: Text(ItemType.validTypes[index].name)),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            child: Row(
              spacing: 32.0,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width * 0.3,
                    color: Colors.redAccent,
                    onPressed: () => Navigator.pop(context),
                    child: const Text('CLOSE'),
                  ),
                ),
                Expanded(
                  child: MaterialButton(
                    padding: EdgeInsets.zero,
                    minWidth: MediaQuery.of(context).size.width * 0.3,
                    color: Colors.amberAccent,
                    onPressed: () async {
                      await controller.removeFilters();
                      context.mounted ? Navigator.pop(context) : null;
                    },
                    child: const Text('REMOVE FILTERS'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
