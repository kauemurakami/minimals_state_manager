library minimals_state_manager;

// lib/min_state.dart

// 1. Exporte o seu Provider e Notifier
export 'app/provider/min_provider.dart';
export 'app/provider/min_multi_provider.dart';
export 'app/state/min_notifier.dart';

// 2. Exporte o seu Widget de alta performance $
export 'app/widgets/min_selector.dart'; // O seu class $

// 3. EXPORTE AS SUAS EXTENSÕES AQUI!
export 'app/extensions/min_provider_extensions.dart'; // Onde estão o .read e .watch
export 'app/state_manager/extensions/min_update.dart';
export 'app/state_manager/service/min_service.dart';

//minimal state manager main
class Min {}
