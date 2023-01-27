import 'package:example/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:minimals_state_manager/app/state_manager/provider/min_provider.dart';
import 'package:minimals_state_manager/app/state_manager/widgets/observable.dart';

class MyPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MyController controller = MinProvider.of(context).controller;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  $(
                      () => Text(
                            '${controller.count.value}',
                            style: const TextStyle(
                                fontSize: 100.0, fontWeight: FontWeight.w700),
                          ),
                      listener: controller.count),
                  $(
                      () => Text(
                            '${controller.user.value.name}',
                            style: const TextStyle(
                                fontSize: 100.0, fontWeight: FontWeight.w700),
                          ),
                      listener: controller.user),
                  $(
                      () => Text(
                            '${controller.user.value.email}',
                            style: const TextStyle(
                                fontSize: 100.0, fontWeight: FontWeight.w700),
                          ),
                      listener: controller.user),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  onChanged: (_) => controller.onChangedName(_),
                                  validator: (_) => controller.validateName(_),
                                  onSaved: (_) => controller.onSavedName(_),
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        print('ok');
                                      }
                                    },
                                    child: const Text(
                                      'change name',
                                      style: TextStyle(fontSize: 32.0),
                                    )),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  onChanged: (_) =>
                                      controller.onChangedEmail(_),
                                  validator: (_) => controller.validateEmail(_),
                                  onSaved: (_) => controller.onSavedEmail(_),
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        print('ok');
                                      }
                                    },
                                    child: const Text(
                                      'change email',
                                      style: TextStyle(fontSize: 32.0),
                                    )),
                              ),
                            ],
                          )
                        ],
                      ))
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () => controller.increment(),
                    child: const Text(
                      'increment',
                      style: TextStyle(fontSize: 32.0),
                    )),
                const Spacer(),
                TextButton(
                    onPressed: () => controller.decrement(),
                    child: const Text(
                      'decrement',
                      style: TextStyle(fontSize: 32.0),
                    ))
              ],
            ),
          ],
        )));
  }
}
