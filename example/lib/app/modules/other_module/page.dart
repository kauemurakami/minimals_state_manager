import 'package:flutter/material.dart';

class OtherPage extends StatelessWidget {
  const OtherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(title: Text('OtherPage')),
        body: SafeArea(
            child: Column(
          children: [
            Text('OtherController'),
          ],
        )));
  }
}
