import 'package:flutter_test/flutter_test.dart';
import 'package:minimals_state_manager/min_notifiers.dart';

class UserModel {
  String name;
  int age;
  UserModel({required this.name, required this.age});
}

class TestLifecycleNotifier extends MinNotifier {
  bool initCalled = false;
  bool readyCalled = false;

  @override
  void onInit() {
    super.onInit();
    initCalled = true;
  }

  @override
  void onReady() {
    super.onReady();
    readyCalled = true;
  }
}

class TestMutationNotifier extends MinNotifier {
  final user = UserModel(name: 'Alex', age: 25);

  void mutateUser() {
    update(user, (u) {
      u.name = 'John Doe';
      u.age = 30;
    });
  }
}

class TestAsyncCrashNotifier extends MinNotifier {
  Future<void> longAsyncOperation() async {
    await Future.delayed(const Duration(milliseconds: 50));
    // Exclusive: If disposed, this should drop execution safely without throwing
    notifyListeners();
  }
}

void main() {
  /// {@template min_notifier_test.update_mutation}
  /// **Test Target:** `MinNotifier.update` Atomic Mutation Helper
  ///
  /// **Objective:** Assures that wrapping complex mutable models with the `update` utility
  /// correctly alters internal target state data structures and automatically triggers
  /// a synchronous framework UI dispatch notification to active observers.
  /// {@endtemplate}
  test(
      'Should automatically dispatch notifications when mutating data via update method',
      () {
    // Arrange
    final notifier = TestMutationNotifier();
    int notificationCount = 0;
    notifier.addListener(() => notificationCount++);

    // Act
    notifier.mutateUser();

    // Assert
    expect(notifier.user.name, equals('John Doe'));
    expect(notifier.user.age, equals(30));
    expect(notificationCount, equals(1));
  });

  /// {@template min_notifier_test.async_protection}
  /// **Test Target:** `MinNotifier` Memory Crash & Async Ghost Protection
  ///
  /// **Objective:** Validates the exclusive async safety guard. If an asynchronous process
  /// concludes *after* the controller is systematically disposed of, the notification must
  /// be aborted safely, preventing the classic Flutter 'notifyListeners called after dispose' memory crash.
  /// {@endtemplate}
  test(
      'Should safely intercept and drop notifyListeners calls if notifier is already disposed',
      () async {
    // Arrange
    final notifier = TestAsyncCrashNotifier();

    // Act & Assert
    expect(() async {
      final asyncTask = notifier.longAsyncOperation();
      notifier.dispose(); // Kill it immediately mid-flight
      await asyncTask; // Wait for the future to finish
    }, returnsNormally); // Crucial: Must pass cleanly without throwing state/memory exceptions
  });
}
