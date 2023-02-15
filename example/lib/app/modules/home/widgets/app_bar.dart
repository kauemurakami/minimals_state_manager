import 'package:example/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:minimals_state_manager/app/widgets/min_widget.dart';
import 'package:minimals_state_manager/app/widgets/minx_widget.dart';

class HomeAppBar extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const HomeAppBar({required this.scaffoldKey, super.key});

  @override
  Widget build(BuildContext context) {
    return MinX<HomeController>(
      builder: (context, controller) => $(
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
            duration: const Duration(milliseconds: 600),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 8,
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
                        child: const Icon(Icons.menu),
                        onTap: () {
                          scaffoldKey!.currentState != null &&
                                  scaffoldKey!.currentState!.isEndDrawerOpen
                              ? scaffoldKey!.currentState!.closeEndDrawer()
                              : scaffoldKey!.currentState!.openEndDrawer();
                        }))
              ],
            ),
          );
        },
        listener: controller.openned,
      ),
    );
  }
}
