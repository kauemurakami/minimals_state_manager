import 'package:example/app/modules/other_module/repository.dart';
import 'package:minimals_state_manager/app/state/min_notifier.dart';

class OtherController extends MinNotifier {
  final OtherRepository repository = OtherRepository();

  OtherController() {
    print('another controller init');
  }
}
