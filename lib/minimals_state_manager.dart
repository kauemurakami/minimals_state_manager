/// A minimalist, high-performance, and boilerplate-free state management library for Flutter.
///
/// This package provides a complete ecosystem for managing application state with
/// focus on developer experience, reactive rebuilding, and structural evaluation:
///
/// * **Reactive State:** Efficiently dispatch and listen to updates via [MinNotifier].
/// * **Granular Rebuilding:** Rebuild only what is strictly necessary with the `$` widget.
/// * **Boilerplate-free Tracking:** Perform deep structural comparison on custom models via [MinProps].
/// * **Dependency Injection:** Scope and inject your states down the widget tree using [MinProvider].
/// * **Lifecycle Awareness:** Monitor app states seamlessly with lifecycle observers.
library minimals_state_manager;

export 'min_notifiers.dart';
export 'min_services.dart';
export 'min_widgets.dart';
export 'min_props.dart';
export 'min_providers.dart';
export 'min_extensions.dart';
export 'min_observers.dart';
