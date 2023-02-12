import 'package:example/app/modules/dash/controller.dart';
import 'package:example/app/modules/dash/page.dart';
import 'package:example/app/modules/home/controller.dart';
import 'package:example/app/modules/home/controller2.dart';
import 'package:flutter/material.dart';
import 'package:minimals_state_manager/app/provider/min_provider.dart';

void main() {
  runApp(MaterialApp(
    home: MinProvider(controller: DashController(), child: const DashPage()),
  ));
}
