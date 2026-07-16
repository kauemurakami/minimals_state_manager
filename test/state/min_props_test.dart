import 'package:flutter_test/flutter_test.dart';
import 'package:minimals_state_manager/minimals_state_manager.dart';

/// A concrete implementation of [MinProps] for testing purposes.
class TestProps extends MinProps {
  final int id;
  final String name;

  TestProps(this.id, this.name);

  @override
  Record get props => (id: id, name: name);
}

/// Another implementation to test runtimeType inequality.
class OtherProps extends MinProps {
  final int id;
  final String name;

  OtherProps(this.id, this.name);

  @override
  Record get props => (id: id, name: name);
}

void main() {
  group('MinProps Tests', () {
    test('Equality should return true for identical instances', () {
      final props = TestProps(1, 'Test');
      expect(props == props, isTrue);
    });

    test('Equality should return true for instances with same values', () {
      final props1 = TestProps(1, 'Test');
      final props2 = TestProps(1, 'Test');

      expect(props1 == props2, isTrue);
      expect(props1.hashCode, equals(props2.hashCode));
    });

    test('Equality should return false for different values', () {
      final props1 = TestProps(1, 'Test');
      final props2 = TestProps(2, 'Different');

      expect(props1 == props2, isFalse);
      expect(props1.hashCode, isNot(equals(props2.hashCode)));
    });

    test('Equality should return false for different types', () {
      final props1 = TestProps(1, 'Test');
      final props2 = OtherProps(1, 'Test');

      expect(props1 == props2, isFalse);
    });

    test(
        'Equality should return false when comparing with null or other objects',
        () {
      final props = TestProps(1, 'Test');

      expect(props == (null as Object?), isFalse);
      expect(props == ('Some String' as Object), isFalse);
    });
  });
}
