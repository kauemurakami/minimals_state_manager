import 'package:example/app/data/services/auth/service.dart';
import 'package:minimals_state_manager/min_services.dart';

final min = MinService.instance;

void setupLocator() {
  min.registerLazySingleton(() => AuthService());
}
