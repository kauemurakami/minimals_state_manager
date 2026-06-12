abstract class MinSnapshot {
  Record get props;

  @override
  bool operator ==(Object other) =>
      runtimeType == other.runtimeType &&
      other is MinSnapshot &&
      props == other.props;

  @override
  int get hashCode => props.hashCode;
}
