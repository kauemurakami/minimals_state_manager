import 'package:flutter/material.dart';

buildBanner(context, {error}) {
  return MaterialBanner(
      backgroundColor: Colors.amber,
      content: Text(
        error ? 'item removed to cart' : 'item added to cart',
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
