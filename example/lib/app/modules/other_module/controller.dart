import 'package:example/app/modules/other_module/repository.dart';
import 'package:minimals_state_manager/app/state_manager/controller/min_controller.dart';

class OtherController extends MinController {
  final OtherRepository repository = OtherRepository();
}
