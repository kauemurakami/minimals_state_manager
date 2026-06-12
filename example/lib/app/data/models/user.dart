import 'package:minimals_state_manager/app/state/min_props.dart';

class User extends MinModel {
  User({this.email, this.name});
  String? name, email;

  @override
  Record get props => (name: name, email: email);
}
