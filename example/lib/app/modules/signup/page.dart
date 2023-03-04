import 'package:flutter/material.dart';
import 'package:minimals_state_manager/app/state_manager/controller/min_controller.dart';

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          leading: BackButton(
            onPressed: () async => Navigator.of(context).pop(),
          ),
        ),
        body: const SafeArea(child: Text('SignupController')));
  }
}
