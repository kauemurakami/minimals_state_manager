import 'package:example/app/data/services/auth/service.dart';
import 'package:example/app/data/services/setup_locator.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  final AuthService _authService = min<AuthService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.red,
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Text(
              'Olá ${_authService.user.name!}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600),
            )),
          ],
        )));
  }
}
