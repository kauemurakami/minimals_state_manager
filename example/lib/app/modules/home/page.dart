import 'package:example/app/modules/home/controller.dart';
import 'package:example/app/modules/home/widgets/app_bar.dart';
import 'package:example/app/modules/home/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:minimals_state_manager/app/widgets/min_widget.dart';
import 'package:minimals_state_manager/app/widgets/minx_widget.dart';
// import 'package:minimals_state_manager/app/state_manager/widgets/page.dart';

class MyPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 50.0),
          child: HomeAppBar(
            scaffoldKey: scaffoldKey,
          )),
      endDrawer: HomeDrawer(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
                child: MinX<HomeController>(
              builder: (context, controller) => ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.items.value.length,
                  itemBuilder: (context, index) => Container(
                        margin: const EdgeInsets.all(6.0),
                        height: 100.0,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(.5),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4.0))),
                        child: Column(children: [
                          Text('${controller.items.value[index].name}$index'),
                          Text('${controller.items.value[index].value}'),
                        ]),
                      )),
            ))
          ],
        ),
      ),
    );
  }
}
