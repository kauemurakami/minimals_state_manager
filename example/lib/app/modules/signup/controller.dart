import 'package:flutter/foundation.dart';
import 'package:minimals_state_manager/min_notifiers.dart';

class SignupController extends MinNotifier {
  @override
  onInit() {
    debugPrint('signup controller init');
  }

  @override
  void onReady() {
    debugPrint('signup controller rendered');
    super.onReady();
  }

  @override
  void dispose() {
    debugPrint('signup controller dispose');
    super.dispose();
  }
}
