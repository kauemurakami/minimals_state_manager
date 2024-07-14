import 'package:example/app/modules/other_module/repository.dart';
import 'package:flutter/foundation.dart';

class OtherController extends ChangeNotifier {
  final OtherRepository repository = OtherRepository();

  OtherController() {
    print('another controller init');
  }
}
