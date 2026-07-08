import 'package:minimals_state_manager/min_notifiers.dart';

class ProfileController extends MinNotifier {
  @override
  onInit() {
    print('profile controller init');
  }

  @override
  void onReady() {
    print('profile controller rendered');
    super.onReady();
  }

  @override
  void dispose() {
    print('profile controller dispose');
    super.dispose();
  }
}
