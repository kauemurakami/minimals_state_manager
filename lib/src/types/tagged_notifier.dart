import 'package:flutter/widgets.dart';

/// Represents a provider entry, either untagged or with a specific tag.
///
/// This is used by [MinMultiProvider] and [MinProvider] to register
/// instances of Notifiers or Services.
typedef TaggedNotifier<T extends ChangeNotifier> = ({
  T Function() create,
  String? tag
});
