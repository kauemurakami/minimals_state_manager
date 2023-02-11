import 'package:example/app/modules/home/controller.dart';
import 'package:flutter/material.dart';

class Sum extends StatelessWidget {
  const Sum({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MinWidget<MyController>(
              builder: (context, controller) => $(
                  () => Text(
                        '${controller.count.value}',
                        style: const TextStyle(fontSize: 100.0),
                      ),
                  listener: controller.count),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MinWidget<MyController>(
                builder: (context, controller) => TextButton(
                    onPressed: () => controller.increment(),
                    child: const Text(
                      'increment',
                      style: TextStyle(fontSize: 32.0),
                    ))),
            const Spacer(),
            MinWidget<MyController>(
                builder: (context, controller) => TextButton(
                    onPressed: () => controller.decrement(),
                    child: const Text(
                      'decrement',
                      style: TextStyle(fontSize: 32.0),
                    )))
          ],
        ),
      ],
    )));
  }
}
