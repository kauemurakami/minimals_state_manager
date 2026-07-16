import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimals_state_manager/min_extensions.dart';
import 'package:minimals_state_manager/min_notifiers.dart';
import 'package:minimals_state_manager/src/types/tagged_notifier.dart';

/// A concrete implementation of ChangeNotifier for testing purposes.
class TestNotifier extends ChangeNotifier {}

class TestMinNotifier extends MinNotifier {}

void main() {
  group('TaggedNotifierExtension Tests', () {
    /// {@template tagged_notifier_extension.tag_method}
    /// **Test Target:** `tag` extension method
    ///
    /// **Objective:** Verifies that the extension correctly converts a
    /// ChangeNotifier instance into a [TaggedNotifier] record with
    /// the expected tag and closure.
    /// {@endtemplate}
    test('tag should return a valid TaggedNotifier record', () {
      final notifier = TestMinNotifier();
      const tagName = 'test_tag';

      // Execute the extension
      final result = notifier.tag(tagName);

      // Verify the record structure
      expect(result, isA<TaggedNotifier<TestMinNotifier>>());
      expect(result.tag, equals(tagName));

      // Verify that the create function returns the exact instance
      final createdNotifier = result.create();
      expect(createdNotifier, equals(notifier));
      expect(createdNotifier, isA<TestMinNotifier>());
    });

    /// {@template tagged_notifier_extension.multiple_tags}
    /// **Test Target:** Multiple tag calls
    ///
    /// **Objective:** Ensures that calling tag multiple times with different
    /// strings works independently and correctly for the same instance.
    /// {@endtemplate}
    test('tag should handle different tags for the same instance', () {
      final notifier = TestNotifier();

      final tagA = notifier.tag('A');
      final tagB = notifier.tag('B');

      expect(tagA.tag, equals('A'));
      expect(tagB.tag, equals('B'));
      expect(tagA.create(), equals(notifier));
      expect(tagB.create(), equals(notifier));
    });
  });
}
