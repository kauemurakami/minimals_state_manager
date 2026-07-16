/// An abstract base class that provides structural equality and hashing based on
/// a provided set of properties.
///
/// Implementations of [MinProps] must provide a [props] record, which is then used
/// to implement [operator ==] and [hashCode]. This ensures that two instances
/// of the same type are considered equal if their property values are identical.
abstract class MinProps {
  /// Creates a [MinProps] instance.
  const MinProps();

  /// The collection of properties that define the equality of this instance.
  ///
  /// This record is used by [operator ==] and [hashCode] to determine structural
  /// equivalence.
  Record get props;

  /// Compares this object with [other] for structural equality.
  ///
  /// Returns `true` if [other] is an instance of the same runtime type and
  /// its [props] are equal to the [props] of this instance.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MinProps &&
          runtimeType == other.runtimeType &&
          props == other.props;

  /// Returns a hash code for this object based on its [runtimeType] and [props].
  @override
  int get hashCode => Object.hash(
        runtimeType,
        props,
      );
}
