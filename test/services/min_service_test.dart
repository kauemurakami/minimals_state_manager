import 'package:flutter_test/flutter_test.dart';
import 'package:minimals_state_manager/min_services.dart'; // Ajuste o import para o seu pacote

abstract class AuthService {}

class AuthServiceImpl implements AuthService {}

abstract class ThemeService {}

class ThemeServiceImpl implements ThemeService {}

void main() {
  late MinService min;

  setUp(() {
    min = MinService.instance;
    min.reset(); // reset di
  });

  /// {@template min_service_test.registration_and_resolution}
  /// **Test Target:** `MinService` Registration & Type Resolution
  ///
  /// **Objective:** Verifies if a classic singleton and a lazy singleton
  /// can be registered cleanly and always return the exact same instance pointer
  /// upon successive retrievals, validating the core O(1) locator map.
  /// {@endtemplate}
  test('Should register and resolve singletons and lazy singletons accurately',
      () {
    // Arrange
    min.registerSingleton<ThemeService>(ThemeServiceImpl());
    min.registerLazySingleton<AuthService>(() => AuthServiceImpl());

    // Act
    final theme1 = min.get<ThemeService>();
    final theme2 =
        min<ThemeService>(); // Testando a chamada direta via callable class
    final auth1 = min.get<AuthService>();
    final auth2 = min.get<AuthService>();

    // Assert
    expect(theme1, isA<ThemeServiceImpl>());
    expect(identityHashCode(theme1), equals(identityHashCode(theme2)));
    expect(auth1, isA<AuthServiceImpl>());
    expect(identityHashCode(auth1), equals(identityHashCode(auth2)));
  });

  /// {@template min_service_test.existence_and_destruction}
  /// **Test Target:** `MinService` Lifecycle Queries & Scoped Destruction
  ///
  /// **Objective:** Assures that `exists<T>()` accurately reports structural registration
  /// state and verifies that invoking `destroy<T>()` completely unloads the instance,
  /// allowing subsequent factory re-allocation without container leaks.
  /// {@endtemplate}
  test(
      'Should accurately check existence and destroy specific service allocations',
      () {
    // Arrange
    min.registerSingleton<ThemeService>(ThemeServiceImpl());
    expect(min.exists<ThemeService>(), isTrue);
    expect(min.exists<AuthService>(), isFalse);

    // Act
    final firstThemeInstance = min.get<ThemeService>();
    min.destroy<ThemeService>();

    // Assert
    expect(min.exists<ThemeService>(), isFalse);

    // Re-register to check if it behaves as a fresh slot
    min.registerSingleton<ThemeService>(ThemeServiceImpl());
    final secondThemeInstance = min.get<ThemeService>();

    expect(identityHashCode(firstThemeInstance),
        isNot(equals(identityHashCode(secondThemeInstance))));
  });
}
