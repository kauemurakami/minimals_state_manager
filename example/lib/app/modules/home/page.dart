import 'package:example/app/data/models/user.dart';
import 'package:example/app/modules/home/controller.dart';
import 'package:example/app/modules/home/controller2.dart';
import 'package:example/app/modules/home/widgets/sum.dart';
import 'package:flutter/material.dart';
import 'package:minimals_state_manager/app/widgets/minx_widget.dart';
import 'package:minimals_state_manager/app/widgets/min_widget.dart';
// import 'package:minimals_state_manager/app/state_manager/widgets/page.dart';

class MyPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MinX<MyController>(
      builder: (context, controller) => Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        MinX<MyController2>(
                          builder: (context, controller) => $(
                            (text) => Text(text),
                            listener: controller.text,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MinX<MyController>(
                              builder: (context, controller) => $<User>(
                                (user) => Text(
                                  '${user.name}',
                                  style: const TextStyle(fontSize: 100.0),
                                ),
                                listener: controller.user,
                              ),
                            ),
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
                ]),
          )),
    );
  }
}
