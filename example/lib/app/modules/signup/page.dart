import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

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
