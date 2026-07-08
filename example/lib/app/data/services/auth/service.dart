import 'package:example/app/data/models/user.dart';
import 'package:minimals_state_manager/min_notifiers.dart';

class AuthService extends MinNotifier {
  final user = User();
  AuthService();

  @override
  void onInit() {
    print('AuthService init');
    super.onInit();
  }

  @override
  void onReady() {
    print('AuthService ready');
    super.onReady();
  }

  Future<void> login() async {
    Future.delayed(const Duration(seconds: 1));
  }
}
