import 'package:example/app/modules/other_module/repository.dart';
import 'package:minimals_state_manager/min_notifiers.dart';

class OtherController extends MinNotifier {
  final OtherRepository repository = OtherRepository();

  @override
  onInit() {
    print('other controller init');
  }

  @override
  void onReady() {
    print('other controller rendered');
    super.onReady();
  }

  @override
  void dispose() {
    print('other controller dispose');
    super.dispose();
  }
}
