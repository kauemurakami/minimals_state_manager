import 'package:example/app/data/services/auth/service.dart';
import 'package:minimals_state_manager/app/state_manager/service/min_service.dart';

final min = MinService.instance;

void setupLocator() {
  min.registerLazySingleton(() => AuthService());
}
