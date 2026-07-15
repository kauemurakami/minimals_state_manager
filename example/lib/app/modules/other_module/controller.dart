import 'package:example/app/modules/other_module/repository.dart';
import 'package:flutter/foundation.dart';
import 'package:minimals_state_manager/min_notifiers.dart';

class OtherController extends MinNotifier {
  final OtherRepository repository = OtherRepository();

  @override
  onInit() {
    debugPrint('other controller init');
  }

  @override
  void onReady() {
    debugPrint('other controller rendered');
    super.onReady();
  }

  @override
  void dispose() {
    debugPrint('other controller dispose');
    super.dispose();
  }
}
