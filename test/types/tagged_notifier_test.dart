import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimals_state_manager/min_notifiers.dart';
import 'package:minimals_state_manager/src/types/tagged_notifier.dart';

/// Dummy class for type verification.
class MockNotifier extends ChangeNotifier {}

class MockMinNotifier extends MinNotifier {}

void main() {
  group('TaggedNotifier Type Definition Tests', () {
    /// {@template tagged_notifier_type.structure}
    /// **Test Target:** [TaggedNotifier] structure
    ///
    /// **Objective:** Verifies that the [TaggedNotifier] typedef correctly
    /// maps to the expected record structure and retains its generic type [T].
    /// {@endtemplate}
    test('TaggedNotifier should correctly alias the record structure', () {
      // Define a valid instance matching the typedef
      final TaggedNotifier<MockNotifier> entry = (
        create: () => MockNotifier(),
        tag: 'test-tag',
      );

      // Verify the members exist and are of the expected types
      expect(entry.create, isA<MockNotifier Function()>());
      expect(entry.tag, equals('test-tag'));

      // Verify execution
      expect(entry.create(), isA<MockNotifier>());
    });

    /// {@template tagged_notifier_type.null_tag}
    /// **Test Target:** [TaggedNotifier] null tag support
    ///
    /// **Objective:** Assures that [TaggedNotifier] supports a null tag,
    /// as specified in the typedef (String?).
    /// {@endtemplate}
    test('TaggedNotifier should accept a null tag', () {
      final TaggedNotifier<MockMinNotifier> entry = (
        create: () => MockMinNotifier(),
        tag: null,
      );

      expect(entry.tag, isNull);
    });
  });
}
