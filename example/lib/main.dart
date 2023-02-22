import 'package:flutter/material.dart';
import 'package:minimals_state_manager/app/provider/min_provider.dart';
import 'package:minimals_state_manager/app/state_manager/controller/min_controller.dart';
import 'package:minimals_state_manager/app/state_manager/extensions/min_listen.dart';
import 'package:minimals_state_manager/app/widgets/minx_widget.dart';
import 'package:minimals_state_manager/app/widgets/observable_widget.dart';

// void main() {
//   setPathUrlStrategy();
//   runApp(const MyApp());
//   // runApp(const MaterialApp()); //normal navigation
// }
void main() {
  runApp(MaterialApp(
    home: MinProvider(controller: MyController(), child: const MyPage()),
  ));
  // runApp(const MaterialApp()); //normal navigation
}

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: MinX<MyController>(
          builder: (context, controller) => Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                backgroundColor: Colors.lightGreen,
                onPressed: () => controller.increment(),
                child: const Icon(Icons.add),
              ),
              const SizedBox(
                height: 16.0,
              ),
              FloatingActionButton(
                backgroundColor: Colors.redAccent,
                onPressed: () => controller.decrement(),
                child: const Icon(Icons.remove),
              ),
              const SizedBox(
                height: 16.0,
              ),
              FloatingActionButton(
                onPressed: () => controller.refresh(),
                child: const Icon(Icons.refresh),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('check out the full example in the example folder'),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MinX<MyController>(
                        builder: (context, controller) => $(
                          (count) => Text(
                            'Count $count',
                            style: const TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          listener: controller.count,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}

class MyController extends MinController {
  @override
  void onInit() {
    print('init controller');
    super.onInit();
  }

  final count = 0.minx;

  increment() => count.value++;
  decrement() => count.value--;
  refresh() => count.value = 0;
}
