// import 'package:flutter/material.dart';

// class MyBanner extends StatelessWidget {
//   final bool error;
//   const MyBanner({super.key, this.error = false}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialBanner(
//         backgroundColor: Colors.amber,
//         content: Text(
//           error ? 'item removed to cart' : 'item added to cart',
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 15.0,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         actions: [
//           GestureDetector(
//             onTap: () =>
//                 ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
//             child: const Text(
//               'OK',
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 15.0,
//                   fontWeight: FontWeight.w500),
//             ),
//           )
//         ]);
//   }
// }
