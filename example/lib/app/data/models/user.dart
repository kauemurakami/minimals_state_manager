import 'package:minimals_state_manager/minimals_state_manager.dart';

class User extends MinProps {
  User({this.email, this.name});
  String? name, email;

  @override
  Record get props => (name: name, email: email);
}
