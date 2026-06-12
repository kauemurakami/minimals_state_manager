abstract class MinModel {
  Record get props;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MinModel &&
          runtimeType == other.runtimeType &&
          props == other.props;

  @override
  int get hashCode => Object.hash(
        runtimeType,
        props,
      );
}
