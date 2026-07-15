import 'package:example/app/data/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:minimals_state_manager/min_notifiers.dart';

class AuthService extends MinNotifier {
  final user = User();
  AuthService();

  @override
  void onInit() {
    debugPrint('AuthService init');
    super.onInit();
  }

  @override
  void onReady() {
    debugPrint('AuthService ready');
    super.onReady();
  }

  Future<void> login() async {
    Future.delayed(const Duration(seconds: 1));
  }
}
