import 'package:minimals_state_manager/app/state/min_props.dart';
import 'package:minimals_state_manager/app/types/min_record.dart';

class User extends MinSnapshot {
  User({this.email, this.name});
  String? name, email;

  @override
  MinRecord get snapshot => ({name: name, email: email});
}
