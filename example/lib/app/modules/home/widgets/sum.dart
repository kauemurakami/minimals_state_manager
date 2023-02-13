// import 'package:example/app/modules/home/controller.dart';
// import 'package:flutter/material.dart';
// import 'package:minimals_state_manager/app/widgets/min_widget.dart';
// import 'package:minimals_state_manager/app/widgets/minx_widget.dart';

// class Sum extends StatelessWidget {
//   const Sum({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             MinX<MyController>(
//               builder: (context, controller) => $<int>(
//                 (count) => Text(
//                   '$count',
//                   style: const TextStyle(fontSize: 100.0),
//                 ),
//                 listener: controller.count,
//               ),
//             ),
//           ],
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             MinX<MyController>(
//                 builder: (context, controller) => TextButton(
//                     onPressed: () => controller.increment(),
//                     child: const Text(
//                       'increment',
//                       style: TextStyle(fontSize: 32.0),
//                     ))),
//             const Spacer(),
//             MinX<MyController>(
//                 builder: (context, controller) => TextButton(
//                     onPressed: () => controller.decrement(),
//                     child: const Text(
//                       'decrement',
//                       style: TextStyle(fontSize: 32.0),
//                     )))
//           ],
//         ),
//       ],
//     );
//   }
// }
