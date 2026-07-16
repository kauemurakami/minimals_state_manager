import 'package:flutter/widgets.dart';

import '../types/tagged_notifier.dart';

/// Allows for a fluent API to assign a tag to a Notifier registration.
extension TaggedNotifierExtension<T extends ChangeNotifier> on T {
  /// Assigns a tag to a notifier instance and converts it to a [TaggedNotifier].
  ///
  /// The [create] function in the record will return this specific instance.
  TaggedNotifier<T> tag(String tag) {
    return (create: () => this, tag: tag);
  }
}
