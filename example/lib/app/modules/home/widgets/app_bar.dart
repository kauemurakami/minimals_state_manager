import 'package:example/app/data/services/auth/service.dart';
import 'package:example/app/modules/home/controller.dart';
import 'package:example/app/modules/home/widgets/filters.dart';
import 'package:flutter/material.dart';
import 'package:minimals_state_manager/min_extensions.dart';
import 'package:minimals_state_manager/min_services.dart';
import 'package:minimals_state_manager/min_widgets.dart';

class HomeAppBar extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  HomeAppBar({required this.scaffoldKey, super.key});
  final AuthService _authService = MinService.instance.get<AuthService>();
  @override
  Widget build(BuildContext context) {
    final controller = context.read<HomeController>();

    return $<HomeController, bool>(
      notifier: controller,
      selector: (notifier) => notifier.openned,
      builder: (context, openned) {
        return AnimatedContainer(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10.0,
              left: 24.0,
              right: 24.0,
              bottom: 14.0),
          color: Colors.amber,
          height: openned
              ? MediaQuery.of(context).size.height * .4
              : MediaQuery.of(context).padding.top,
          duration: const Duration(milliseconds: 100),
          child: Visibility(
            visible: controller.openned,
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
                        onTap: () => debugPrint('search'),
                      )),
                    ],
                  ),
                ),
                Flexible(
                    child: Text(
                  'Olá ${_authService.user.name!}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                )),
                Flexible(
                    child: InkWell(
                  child: const Icon(Icons.filter_list),
                  onTap: () => showModalBottomSheet(
                    enableDrag: true,
                    context: context,
                    builder: (context) => BSFilters(controller: controller),
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
