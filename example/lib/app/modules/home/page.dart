import 'package:example/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:minimals_state_manager/app/state_manager/widgets/min_widget.dart';
import 'package:minimals_state_manager/app/state_manager/widgets/observable.dart';
import 'package:minimals_state_manager/app/state_manager/widgets/page.dart';

class MyPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MinWidget<MyController>(
      builder: (context, controller) => Scaffold(
          body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                $(() => Text('${controller.count.value}'),
                    listener: controller.count),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                $(() => Text('${controller.count.value}'),
                    listener: controller.count),
              ],
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
          ])),
    );
  }
}
