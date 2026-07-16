import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimals_state_manager/min_services.dart';

// --- Test Helper Classes ---

abstract class AuthService {}

class AuthServiceImpl implements AuthService {}

abstract class ThemeService {}

class ThemeServiceImpl implements ThemeService {}

/// Helper class to verify that [dispose] is correctly called.
class TestChangeNotifier extends ChangeNotifier {
  bool disposed = false;

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }
}

void main() {
  late MinService min;

  setUp(() {
    min = MinService.instance;
    min.reset();
  });

  /// {@template min_service_test.registration_and_resolution}
  /// **Test Target:** `MinService` Registration & Type Resolution
  ///
  /// **Objective:** Verifies if a classic singleton and a lazy singleton
  /// can be registered cleanly and return the exact same instance pointer.
  /// {@endtemplate}
  test('Should register and resolve singletons and lazy singletons accurately',
      () {
    // Arrange
    min.registerSingleton<ThemeService>(ThemeServiceImpl());
    min.registerLazySingleton<AuthService>(() => AuthServiceImpl());

    // Act
    final theme1 = min.get<ThemeService>();
    final theme2 = min<ThemeService>();
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
  /// **Objective:** Assures that `exists<T>()` reports accurately and
  /// `destroy<T>()` unloads the instance properly.
  /// {@endtemplate}
  test(
      'Should accurately check existence and destroy specific service allocations',
      () {
    min.registerSingleton<ThemeService>(ThemeServiceImpl());
    expect(min.exists<ThemeService>(), isTrue);
    expect(min.exists<AuthService>(), isFalse);

    final firstThemeInstance = min.get<ThemeService>();
    min.destroy<ThemeService>();

    expect(min.exists<ThemeService>(), isFalse);

    min.registerSingleton<ThemeService>(ThemeServiceImpl());
    final secondThemeInstance = min.get<ThemeService>();

    expect(identityHashCode(firstThemeInstance),
        isNot(equals(identityHashCode(secondThemeInstance))));
  });

  /// {@template min_service_test.error_handling}
  /// **Test Target:** `MinService` Assertions
  ///
  /// **Objective:** Verifies that requesting an unregistered service throws
  /// the expected assertion error.
  /// {@endtemplate}
  test('Should throw an assertion error when resolving an unregistered type',
      () {
    expect(() => min.get<String>(), throwsAssertionError);
  });

  /// {@template min_service_test.disposable_handling}
  /// **Test Target:** `MinService` Disposal Logic
  ///
  /// **Objective:** Verifies that instances implementing ChangeNotifier
  /// are correctly disposed during destruction.
  /// {@endtemplate}
  test('Should call dispose() on ChangeNotifier instances', () {
    final disposableService = TestChangeNotifier();
    min.registerSingleton<TestChangeNotifier>(disposableService);

    expect(disposableService.disposed, isFalse);

    // This triggers the lines 92 and 110 of your MinService
    min.destroy<TestChangeNotifier>();

    expect(disposableService.disposed, isTrue);
  });

  /// {@template min_service_test.deep_cleanup}
  /// **Test Target:** `MinService` Deep Cleanup
  ///
  /// **Objective:** Verifies that destruction correctly removes both active
  /// instances and lazy builders, and ensures that destroyAll processes
  /// all registered ChangeNotifier instances.
  /// {@endtemplate}
  test(
      'Should fully clear builders and dispose all change notifiers on destruction',
      () {
    // 1. Arrange: Register a lazy singleton and a singleton ChangeNotifier
    min.registerLazySingleton<AuthService>(() => AuthServiceImpl());
    final disposable = TestChangeNotifier();
    min.registerSingleton<TestChangeNotifier>(disposable);

    // 2. Act: Destroy the lazy singleton
    // This covers line 102: _builders.remove(type)
    min.destroy<AuthService>();

    // 3. Act: Use destroyAll for the ChangeNotifier
    // This covers line 110: instance.dispose()
    min.destroyAll();

    // 4. Assert
    expect(min.exists<AuthService>(), isFalse);
    expect(disposable.disposed, isTrue);
  });

  /// {@template min_service_test.builder_removal}
  /// **Test Target:** `MinService.destroy` - Builder Removal
  ///
  /// **Objective:** Verifies that when `destroy<T>()` is called, the corresponding
  /// builder function is removed from the internal `_builders` map.
  /// {@endtemplate}
  test('Should remove lazy builder from _builders map when destroy is called',
      () {
    // Arrange: Register a lazy singleton
    min.registerLazySingleton<AuthService>(() => AuthServiceImpl());

    // Act: Destroy the service.
    // This explicitly triggers the 'if (_builders.containsKey(type))' block
    // and the '_builders.remove(type)' line (Line 102).
    min.destroy<AuthService>();

    // Assert: Verify builder is gone by trying to resolve it (should throw error)
    expect(() => min.get<AuthService>(), throwsAssertionError);
  });

  /// {@template min_service_test.destroy_all_notifiers}
  /// **Test Target:** `MinService.destroyAll` - Deep Disposal
  ///
  /// **Objective:** Ensures that `destroyAll()` successfully iterates through all
  /// instances and invokes `dispose()` on any registered `ChangeNotifier`.
  /// {@endtemplate}
  test('Should call dispose on all ChangeNotifiers during destroyAll', () {
    // Arrange: Register multiple ChangeNotifier instances to ensure the loop
    // in destroyAll (Line 108) runs and executes dispose (Line 110).
    final notifier1 = TestChangeNotifier();
    final notifier2 = TestChangeNotifier();

    min.registerSingleton<TestChangeNotifier>(notifier1);
    // Registering as the base class to test the 'is ChangeNotifier' check
    min.registerSingleton<ChangeNotifier>(notifier2);

    // Act: Invoke global destruction
    min.destroyAll();

    // Assert: Verify that both notifiers were properly disposed of
    expect(notifier1.disposed, isTrue);
    expect(notifier2.disposed, isTrue);
  });
}
