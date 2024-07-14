import 'package:example/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:minimals_state_manager/app/provider/min_provider.dart';
import 'package:minimals_state_manager/app/widgets/observable_widget.dart';

class BSFilters extends StatelessWidget {
  const BSFilters({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MinProvider.use<HomeController>(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        // color: Colors.grey,
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
              child: $(
                controller.filter,
                (filter) => ListView.builder(
                  // scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () => controller.changeFilter(index + 1),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      height: MediaQuery.of(context).size.height * 0.06,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: controller.filter.value != 0 &&
                                    (index + 1 == filter)
                                ? Colors.green
                                : Colors.amber),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(6.0),
                        ),
                      ),
                      child: Center(child: Text('Type : ${index + 1}')),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                  minWidth: MediaQuery.of(context).size.width * 0.3,
                  color: Colors.redAccent,
                  onPressed: () => Navigator.pop(context),
                  child: const Text('CLOSE'),
                ),
                MaterialButton(
                  padding: EdgeInsets.zero,
                  minWidth: MediaQuery.of(context).size.width * 0.3,
                  color: Colors.amberAccent,
                  onPressed: () async {
                    await controller.removeFilters();
                    context.mounted ? Navigator.pop(context) : null;
                  },
                  child: const Text('REMOVE FILTERS'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
