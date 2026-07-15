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

export 'src/extensions/min_provider_extensions.dart';
export 'src/state/min_notifier.dart';
export 'src/services/min_service.dart';
export 'src/widgets/min_selector.dart';
export 'src/widgets/min_widget.dart';
export 'src/state/min_props.dart';
export 'src/providers/min_multi_provider.dart';
export 'src/providers/min_provider.dart';
export 'src/observers/min_app_lifecycle.dart';
