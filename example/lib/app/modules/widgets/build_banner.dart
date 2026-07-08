import 'package:flutter/material.dart';

buildBanner(context, {required String message, required bool isRemoved}) {
  return MaterialBanner(
      onVisible: () async {
        await Future.delayed(Durations.medium1);
        ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
      },
      backgroundColor: isRemoved ? Colors.red : Colors.green,
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () =>
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
          child: const Text(
            'OK',
            style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.w500),
          ),
        )
      ]);
}
