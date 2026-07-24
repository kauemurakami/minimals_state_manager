import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimals_state_manager/min_notifiers.dart';
import 'package:minimals_state_manager/min_services.dart';

// --- Test Helper Classes ---

abstract class AuthService {}

class AuthServiceImpl implements AuthService {}

abstract class ThemeService {}

class ThemeServiceImpl implements ThemeService {}

/// Helper class to verify that [dispose] is correctly called.
class TestChangeNotifier extends MinNotifier {
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

  group('MinService without tag Tests', () {
    /// {@template min_service_test.registration_and_resolution}
    /// **Test Target:** `MinService` Registration & Type Resolution
    ///
    /// **Objective:** Verifies if a classic singleton and a lazy singleton
    /// can be registered cleanly and return the exact same instance pointer.
    /// {@endtemplate}
    test(
        'Should register and resolve singletons and lazy singletons accurately',
        () {
      // Arrange
      min.registerSingleton<ThemeService>(ThemeServiceImpl());
      min.registerLazySingleton<AuthService>(() => AuthServiceImpl());

      // Act
      final theme1 = min.get<ThemeService>();
      final theme2 = min.get<ThemeService>();
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
    /// **Test Target:** `MinService` Error Handling
    ///
    /// **Objective:** Verifies that requesting an unregistered service throws
    /// the expected [Exception].
    /// {@endtemplate}
    test('Should throw an exception when resolving an unregistered type', () {
      expect(() => min.get<String>(), throwsException);
    });

    /// {@template min_service_test.async_not_found_error_handling}
    /// **Test Target:** `MinService` Async Error Handling for Unregistered Types
    ///
    /// **Objective:** Verifies that calling `getAsync` on an unregistered type
    /// throws the exception covering the unassigned async fallback lines.
    /// {@endtemplate}
    test(
        'Should throw an exception when resolving an unregistered type via getAsync',
        () async {
      // This explicitly covers lines 154-156 (tagMsg and Exception throw in getAsync)
      expect(() => min.getAsync<String>(), throwsException);
      expect(() => min.getAsync<String>(tag: 'missing_async_tag'),
          throwsException);
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
      min.registerLazySingleton<AuthService>(() => AuthServiceImpl());
      final disposable = TestChangeNotifier();
      min.registerSingleton<TestChangeNotifier>(disposable);

      min.destroy<AuthService>();
      min.destroyAll();

      expect(min.exists<AuthService>(), isFalse);
      expect(disposable.disposed, isTrue);
    });

    /// {@template min_service_test.builder_removal}
    /// **Test Target:** `MinService.destroy` - Builder Removal
    ///
    /// **Objective:** Verifies that when `destroy<T>()` is called, the corresponding
    /// builder function is removed from the internal maps.
    /// {@endtemplate}
    test('Should remove lazy builder from builders map when destroy is called',
        () {
      min.registerLazySingleton<AuthService>(() => AuthServiceImpl());

      min.destroy<AuthService>();

      expect(() => min.get<AuthService>(), throwsException);
    });

    /// {@template min_service_test.destroy_all_notifiers}
    /// **Test Target:** `MinService.destroyAll` - Deep Disposal
    ///
    /// **Objective:** Ensures that `destroyAll()` successfully iterates through all
    /// instances and invokes `dispose()` on any registered `ChangeNotifier`.
    /// {@endtemplate}
    test('Should call dispose on all ChangeNotifiers during destroyAll', () {
      final notifier1 = TestChangeNotifier();
      final notifier2 = TestChangeNotifier();

      min.registerSingleton<TestChangeNotifier>(notifier1);
      min.registerSingleton<ChangeNotifier>(notifier2);

      min.destroyAll();

      expect(notifier1.disposed, isTrue);
      expect(notifier2.disposed, isTrue);
    });

    /// {@template min_service_test.async_registration_and_resolution}
    /// **Test Target:** `MinService` Async Registration & Resolution
    ///
    /// **Objective:** Verifies that `registerSingletonAsync` and `getAsync`
    /// successfully execute the asynchronous builder once, cache the instance,
    /// and disallow synchronous `get()` access prior to resolution.
    /// {@endtemplate}
    test('Should register and resolve async singletons correctly via getAsync',
        () async {
      bool initialized = false;

      min.registerSingletonAsync<AuthService>(() async {
        await Future.delayed(const Duration(milliseconds: 10));
        initialized = true;
        return AuthServiceImpl();
      });

      expect(() => min.get<AuthService>(), throwsException);

      expect(initialized, isFalse);

      final instance1 = await min.getAsync<AuthService>();
      expect(instance1, isA<AuthServiceImpl>());
      expect(initialized, isTrue);

      final instance2 = await min.getAsync<AuthService>();
      expect(identityHashCode(instance1), equals(identityHashCode(instance2)));
    });

    /// {@template min_service_test.lazy_async_registration_and_resolution}
    /// **Test Target:** `MinService` Lazy Async Registration & Resolution
    ///
    /// **Objective:** Verifies that `registerLazySingletonAsync` works precisely
    /// like its eager counterpart, executing only on the first `getAsync()` call.
    /// {@endtemplate}
    test(
        'Should register and resolve lazy async singletons correctly via getAsync',
        () async {
      int buildCount = 0;

      min.registerLazySingletonAsync<ThemeService>(() async {
        buildCount++;
        await Future.delayed(const Duration(milliseconds: 10));
        return ThemeServiceImpl();
      });

      expect(buildCount, equals(0));

      final instance1 = await min.getAsync<ThemeService>();
      expect(instance1, isA<ThemeServiceImpl>());
      expect(buildCount, equals(1));

      final instance2 = await min.getAsync<ThemeService>();
      expect(identityHashCode(instance1), equals(identityHashCode(instance2)));
      expect(buildCount, equals(1));
    });

    /// {@template min_service_test.async_concurrent_resolution}
    /// **Test Target:** `MinService` Concurrent Async Resolution
    ///
    /// **Objective:** Verifies that multiple simultaneous calls to `getAsync()`
    /// share the exact same pending initialization future without executing
    /// the async builder multiple times.
    /// {@endtemplate}
    test('Should handle concurrent getAsync requests gracefully', () async {
      int executionCount = 0;

      min.registerSingletonAsync<AuthService>(() async {
        executionCount++;
        await Future.delayed(const Duration(milliseconds: 50));
        return AuthServiceImpl();
      });

      final future1 = min.getAsync<AuthService>();
      final future2 = min.getAsync<AuthService>();

      final results = await Future.wait([future1, future2]);

      expect(results[0], isA<AuthServiceImpl>());
      expect(
          identityHashCode(results[0]), equals(identityHashCode(results[1])));
      expect(executionCount, equals(1));
    });

    /// {@template min_service_test.async_fallback_to_sync_get}
    /// **Test Target:** `MinService` Async Fallback on Sync Get
    ///
    /// **Objective:** Verifies that calling `get()` on a lazy sync builder
    /// resolves correctly even if async builders are registered in the locator.
    /// {@endtemplate}
    test('Should resolve sync lazy builder through getAsync cleanly', () async {
      min.registerLazySingleton<AuthService>(() => AuthServiceImpl());

      final instance = await min.getAsync<AuthService>();
      expect(instance, isA<AuthServiceImpl>());
    });
  });

  group('MinService Tagged Tests', () {
    /// {@template min_service_test.tagged_resolution}
    /// **Test Target:** `MinService` Tagged Resolution
    ///
    /// **Objective:** Verifies that services registered with tags are isolated
    /// and do not conflict with each other or untagged instances.
    /// {@endtemplate}
    test('Should register and resolve services with specific tags', () {
      final serviceA = AuthServiceImpl();
      final serviceB = AuthServiceImpl();

      min.registerSingleton<AuthService>(serviceA, tag: 'primary');
      min.registerSingleton<AuthService>(serviceB, tag: 'secondary');

      expect(min.get<AuthService>(tag: 'primary'), equals(serviceA));
      expect(min.get<AuthService>(tag: 'secondary'), equals(serviceB));
      expect(min.get<AuthService>(tag: 'primary'),
          isNot(equals(min.get<AuthService>(tag: 'secondary'))));
    });

    /// {@template min_service_test.tagged_lazy_resolution}
    /// **Test Target:** `MinService` Tagged Lazy Resolution
    ///
    /// **Objective:** Ensures that lazy builders respect the provided tag.
    /// {@endtemplate}
    test('Should resolve tagged lazy singletons correctly', () {
      min.registerLazySingleton<AuthService>(() => AuthServiceImpl(),
          tag: 'lazy');

      final instance = min.get<AuthService>(tag: 'lazy');
      expect(instance, isA<AuthServiceImpl>());
      expect(min.exists<AuthService>(tag: 'lazy'), isTrue);
    });

    /// {@template min_service_test.tagged_async_resolution}
    /// **Test Target:** `MinService` Tagged Async Resolution
    ///
    /// **Objective:** Verifies that asynchronous registration works with tags
    /// and isolates separate instances successfully.
    /// {@endtemplate}
    test('Should register and resolve tagged async singletons correctly',
        () async {
      min.registerSingletonAsync<AuthService>(() async {
        return AuthServiceImpl();
      }, tag: 'auth_tag');

      final instance = await min.getAsync<AuthService>(tag: 'auth_tag');
      expect(instance, isA<AuthServiceImpl>());
      expect(min.exists<AuthService>(tag: 'auth_tag'), isTrue);
    });

    /// {@template min_service_test.tagged_error_handling}
    /// **Test Target:** `MinService` Tagged Not Found
    ///
    /// **Objective:** Verifies that requesting a tag that does not exist
    /// throws an exception with the correct message.
    /// {@endtemplate}
    test('Should throw exception when requesting non-existent tag', () {
      min.registerSingleton<AuthService>(AuthServiceImpl(), tag: 'exists');

      expect(() => min.get<AuthService>(tag: 'missing'), throwsException);
    });

    /// {@template min_service_test.tagged_destruction}
    /// **Test Target:** `MinService` Tagged Destruction
    ///
    /// **Objective:** Verifies that destroying an instance with a tag
    /// does not affect other instances (tagged or untagged).
    /// {@endtemplate}
    test('Should destroy only the tagged instance', () {
      min.registerSingleton<AuthService>(AuthServiceImpl(), tag: 'A');
      min.registerSingleton<AuthService>(AuthServiceImpl(), tag: 'B');

      min.destroy<AuthService>(tag: 'A');

      expect(min.exists<AuthService>(tag: 'A'), isFalse);
      expect(min.exists<AuthService>(tag: 'B'), isTrue);
    });

    /// {@template min_service_test.tagged_disposal}
    /// **Test Target:** `MinService` Tagged Disposal
    ///
    /// **Objective:** Verifies that tagged ChangeNotifier instances are disposed.
    /// {@endtemplate}
    test('Should call dispose on tagged ChangeNotifier during destruction', () {
      final notifier = TestChangeNotifier();
      min.registerSingleton<TestChangeNotifier>(notifier, tag: 'notifier_tag');

      min.destroy<TestChangeNotifier>(tag: 'notifier_tag');
      expect(notifier.disposed, isTrue);
    });
  });
}
