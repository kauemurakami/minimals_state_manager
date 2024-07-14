import 'package:example/app/modules/home/controller.dart';
import 'package:example/app/modules/home/widgets/filters.dart';
import 'package:flutter/material.dart';
import 'package:minimals_state_manager/app/provider/min_provider.dart';
import 'package:minimals_state_manager/app/widgets/observable_widget.dart';

class HomeAppBar extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const HomeAppBar({required this.scaffoldKey, super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MinProvider.use<HomeController>(context);

    return $(
      controller.openned,
      (_) {
        return AnimatedContainer(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10.0,
              left: 24.0,
              right: 24.0,
              bottom: 14.0),
          color: Colors.amber,
          height: _
              ? MediaQuery.of(context).size.height * .4
              : MediaQuery.of(context).padding.top,
          duration: const Duration(milliseconds: 100),
          child: Visibility(
            visible: controller.openned.value,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 6,
                  child: Row(
                    children: [
                      Flexible(
                        flex: 8,
                        child: TextField(
                          controller: controller.textController,
                        ),
                      ),
                      Flexible(
                          child: InkWell(
                        child: const Icon(Icons.search),
                        onTap: () => print('search'),
                      )),
                    ],
                  ),
                ),
                Flexible(
                    child: InkWell(
                  child: const Icon(Icons.filter_list),
                  onTap: () => showBottomSheet(
                    enableDrag: true,
                    context: context,
                    builder: (context) => const BSFilters(),
                  ),
                )),
                Flexible(
                    child: InkWell(
                        child: const Icon(Icons.menu),
                        onTap: () {
                          scaffoldKey!.currentState != null &&
                                  scaffoldKey!.currentState!.isEndDrawerOpen
                              ? scaffoldKey!.currentState!.closeEndDrawer()
                              : scaffoldKey!.currentState!.openEndDrawer();
                        }))
              ],
            ),
          ),
        );
      },
    );
  }
}
