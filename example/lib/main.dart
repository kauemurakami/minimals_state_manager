import 'package:example/app/modules/home/controller.dart';
import 'package:example/app/modules/home/controller2.dart';
import 'package:example/app/modules/home/page.dart';
import 'package:flutter/material.dart';
import 'package:minimals_state_manager/app/state_manager/provider/min_multi_provider.dart';

void main() {
  runApp(MaterialApp(
    home: MinMultiProvider(
        controllers: [MyController(), MyController2()], child: MyPage()),
  ));
}
