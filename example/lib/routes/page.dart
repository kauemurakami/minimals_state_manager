import 'package:flutter/material.dart';

/// _ Map args
class AppPage {
  final Widget Function(Map<String, String> _) builder;
  final String? path;
  AppPage(this.builder, {required this.path});
}
