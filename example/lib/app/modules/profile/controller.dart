import 'package:flutter/foundation.dart';
import 'package:minimals_state_manager/min_notifiers.dart';

class ProfileController extends MinNotifier {
  @override
  onInit() {
    debugPrint('profile controller init');
  }

  @override
  void onReady() {
    debugPrint('profile controller rendered');
    super.onReady();
  }

  @override
  void dispose() {
    debugPrint('profile controller dispose');
    super.dispose();
  }
}
