import 'package:example/app/modules/home/controller.dart';
import 'package:example/app/modules/home/controller2.dart';
import 'package:example/app/modules/home/widgets/sum.dart';
import 'package:flutter/material.dart';
import 'package:minimals_state_manager/app/state_manager/widgets/min_widget.dart';
import 'package:minimals_state_manager/app/state_manager/widgets/minx_widget.dart';
// import 'package:minimals_state_manager/app/state_manager/widgets/page.dart';

class MyPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MinWidget<MyController>(
      builder: (context, controller) => Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      MinWidget<MyController2>(
                          builder: (context, controller) =>
                              Text(controller.text.value)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          $(
                              () => Text(
                                    '${controller.user.value.name}',
                                    style: const TextStyle(fontSize: 100.0),
                                  ),
                              listener: controller.user),
                        ],
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                onChanged: (_) => controller.onChangedName(_),
                                validator: (_) => controller.validateName(_),
                                onSaved: (_) => controller.onSavedName(_),
                              )
                            ],
                          )),
                    ],
                  ),
                ),
                Expanded(child: Sum())
              ])),
    );
  }
}
