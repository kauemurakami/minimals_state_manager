import 'package:minimals_state_manager/min_notifiers.dart';

class SignupController extends MinNotifier {
  @override
  onInit() {
    print('signup controller init');
  }

  @override
  void onReady() {
    print('signup controller rendered');
    super.onReady();
  }

  @override
  void dispose() {
    print('signup controller dispose');
    super.dispose();
  }
}
