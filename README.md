[![Star on GitHub](https://img.shields.io/github/stars/kauemurakami/minimals_state_manager.svg?style=flat&logo=github&colorB=deeppink&label=stars)](https://github.com/kauemurakami/minimals_state_manager)
[![Build Status](https://github.com/kauemurakami/minimals_state_manager/actions/workflows/tests.yaml/badge.svg)](https://github.com/kauemurakami/minimals_state_manager/actions)
[![codecov](https://codecov.io/github/kauemurakami/minimals_state_manager/graph/badge.svg?token=0GWG7GRHEN)](https://codecov.io/github/kauemurakami/minimals_state_manager)
[![Pub Version](https://img.shields.io/pub/v/minimals_state_manager?style=flat-square&color=teal)](https://pub.dev/packages/minimals_state_manager)
[![Pub Points](https://img.shields.io/pub/points/minimals_state_manager?style=flat-square&color=blue)](https://pub.dev/packages/minimals_state_manager)
[![Benchmarks](https://img.shields.io/badge/Performance-Benchmarks-blueviolet?style=flat&logo=dart&logoColor=white)](https://github.com/kauemurakami/minimals_state_manager/blob/main/BENCHMARKS.md)

# Minimals State Manager

A fastest, lightweight, high-performance, and boilerplate-free state management and dependency injection solution for Flutter.

## Why Minimals?

*   **Zero Code Generation:** No `build_runner`, no waiting, no generated files. Just pure Dart.
*   **Flutter-Only Dependencies:** Built completely as a clean abstraction over Flutter's native classes (`InheritedWidget`, `ChangeNotifier`, `Listenable`).
*   **The Best of Three Worlds:** It combines the intuitive lifecycle of **GetX**, the scoped architecture of **Provider**, and the ultra-fast service location of **GetIt**.
*   **Highly Flexible:** You can use `MinNotifier`, standard `ChangeNotifier`, `ValueNotifier`, or any `Listenable` out of the box.

---

## Features

### MinService
#### Setup and Registration
`MinService` is an embedded service locator built directly into the package. If you are familiar with `GetIt`, you will feel right at home. It handles application-wide or lazy singletons cleanly without requiring external dependencies.  
The Power of Tags: You can use the `tag:'your-tag'`attribute when register your `singletons` or `lazySingletons` with any `notifier` to create isolated, context-aware instances (e.g., Admin vs Guest notifiers) without creating separate classes.

```dart
import 'package:flutter/material.dart';
import 'package:minimals_state_manager/min_notifiers.dart';

final min = MinService.instance;

void setupLocator() {
  //usage with global instance
  min.registerLazySingleton(() => AuthService());
  min.registerSingleton<ThemeService>(ThemeService());
  //or use directly instance
  MinService.instance.registerLazySingleton(() => AuthService());
  MinService.instance.registerSingleton<ThemeService>(ThemeService());
  //or using with tags
  min.registerLazySingleton(() => AuthService(), tag: 'initial');
  MinService.instance.registerSingleton<AuthService>(AuthService(), tag: 'global');

}

void main() {
  setPathUrlStrategy();
  setupLocator();
  runApp(const MyApp());
}
```
#### Retrieving and Managing your Services
```dart
//usage with global instance
final authService = min<AuthService>();
final themeService = min.get<ThemeService>();
//or using directly instance
final anotherService = MinService.instance<MyService>();
//or using tags
final authService = min<AuthService>(tag: 'global')

bool exists = min.exists<AuthService>();

min.destroy<AuthService>();
min.reset();
```
You can use a global instance `final min = MinService.instance` and reuse in global code escope or use directly `MinService.instance` to use any `MinService` method.  
**Benefits**: Decouples your business logic from the UI layer, guarantees memory efficiency through lazy initialization, and speeds up testing.  

#### More about tags
Lookups are highly flexible and intuitive. If you search for a `notifier` or `service` without specifying a `tag`, the system will automatically look for the `default untagged instance` of that class. Tags act as strict qualifiers, meaning tagged instances remain completely isolated and will never interfere with your standard, untagged state declarations. If you attempt to retrieve a specific instance (tagged or untagged) that has not been registered or is not currently available within the lookup context, the system will `throw` a `FlutterError` to ensure you are alerted to missing dependencies during development.

### Providers
Providers manage the complete setup, `lifecycle`, and `destruction` of your state `notifier` in the widget tree.
Providers inject, govern, and bound your state `notifiers` directly to specific segments of the Flutter Widget Tree. You don't need to be tied to our `MinNotifier``.
They are completely decoupled from any single state architecture: you can pass our specialized MinNotifier, a standard `ChangeNotifier`, a `ValueNotifier`, or any custom class implementing the native `Listenable` interface.

Additionally, Providers fully support `tags`, allowing you to register `multiple instances of the same class` within the widget tree. By appending the `tag` attribute to your `MinProvider`, you can create isolated, context-aware state instances (e.g., separating Admin and User `notifier`) without creating complex inheritance hierarchies or duplicating code.

#### Single Provider
```dart
MinProvider<HomeNotifier>(
  create: () => HomeNotifier(),
  child: const HomePage(),
);
```

```dart
MinProvider<HomeNotifier>(
  create: () => HomeNotifier(),
  tag: 'main-page',
  child: const HomePage(),
);
```

#### Multi Provider
When a page requires **multiple** `notifiers, use MinMultiProvider` to avoid deeply nested trees `("provider pyramids")`. This allows you to centralize your state dependencies at the top of your widget tree, keeping your UI code clean and readable.

`MinMultiProvider` also features robust support for `tags`. By utilizing the `.tag()` method on your notifiers within the create list, you can register `multiple instances of the same type within a single provider`, enabling precise, isolated state management (e.g., distinguishing between different user roles or `multi-window contexts`) without any `lookup overhead`.

```dart
MinMultiProvider(
  create: [
    () => CartNotifier(),
    () => HomeController(),
    () => UserProfileViewModel(),
    () => SettingsStore(),
    () => SettingsStore().tag('global'),
  ],
  child: const HomePage(),
)
```
**Benefits**: Handles memory cleanup automatically. When the route is popped or destroyed, the notifiers are safely disposed.  

### Accessing Notifiers in the UI
You can interact with your providers using either traditional static methods or sleek modern BuildContext extensions.  

#### Static Methods
```dart
final controller = MinProvider.watch<HomeController>(context);
final viewModel = MinProvider.read<HomeViewModel>(context);

final notifier = MinMultiProvider.watch<HomeNotifier(context);
final store = MinMultiProvider.read<HomeStore>(context);
// with tags
final notifier = MinMultiProvider.watch<HomeNotifier(context, tag: 'main');
final store = MinMultiProvider.read<HomeStore>(context, tag: 'main');
```

#### BuildContext Extensions (Cleanest)
```dart
final viewModel = context.watch<HomeViewModel>();
final controller = context.read<HomeController>();
//or using tag
final viewModel = context.watch<HomeViewModel>(ag: 'main-home-viewModel');
final controller = context.read<HomeController>(tag: 'main-home-controller');
```

### MinNotifier
Minimals gives you absolute freedom when defining your business logic layers. You can use standard Flutter classes like `ChangeNotifier`, `ValueNotifier`, or any custom class that extends `Listenable`, its work with our `MinProvider`, `MinMultiProvider` and `MinService`.   
However, by extending our specialized **`MinNotifier`**, you gain access to structured architectural lifecycles (`onInit` and `onReady`) along with built-in protection against asynchronous state update crashes.  

```dart
class HomeNotifier extends MinNotifier {
  final repository = HomeRepository();
  List<Item> items = [];

  @override
  void onInit() {
    super.onInit();
    // Synchronous execution. Runs immediately as the object is allocated.
    // Perfect for setting up hardware listeners or stream initializations.
    setupScrollListeners();
  }

  @override
  void onReady() {
    super.onReady();
    // Post-frame execution. Runs safely immediately after the first frame draws.
    // Ideal for safe navigation triggers or making remote server calls.
    fetchItems();
  }

  Future<void> fetchItems() async {
    items = await repository.getItems();
    
    // 🛡️ BUILT-IN CRASH PROTECTION (Exclusive to MinNotifier)
    // If the user navigates away before this asynchronous network call finishes, 
    // MinNotifier intercepts this call and drops the execution sequence safely,
    // avoiding standard Flutter framework memory crashes.
    notifyListeners();
  }

  ...

  @override
  void dispose() {
    // Teardown local notifier references or native subscriptions cleanly here
    super.dispose();
  }
}
```
⚡ Smart In-Place Updates (The update utility)
When managing complex models, deep nested entities, or mutable data structures, writing manual boilerplate sequences just to trigger an update is tedious. `MinNotifier` introduces the `update` helper, which automatically runs your mutations and systematically fires the notification layer for you in a single, clean expression.
```dart
class ProfileController extends MinNotifier {
  final user = User(name: 'Alex', age: 25);

  void updateUserProfile() {
    // Mutates internal properties and automatically triggers a UI rebuild!
    update(user, (p) {
      p.name = 'John Doe';
      p.age = 30;
    });
  }
}
```

### Structured Data Objects
#### MinProps
`MinProps` is a lightweight structural layout class designed to bridge concrete data object instances with Dart's modern Records system, enabling fast, boilerplate-free value comparisons.  
```dart 
class User extends MinProps {
  final String name;
  final String email;

  User({required this.name, required this.email});

  // Expose specific field values as a native immutable Dart Record type
  @override
  get props => (name: name, email: email); 
}
```
Manual Insight: By overriding props, MinProps lets you avoid writing long manual overrides for == and hashCode signatures. It enables fast value comparisons when filtering state updates within user views.  

This will be useful if you need to observe state changes in a complex object—such as `User` via our selector widget. To avoid developer boilerplate and the need to recreate object instances, you can simply extend `MinProps` in your model and implement the object's attributes, turning it into a record that can then be observed; you will understand this better in the next section.  

### Granular Rebuild Isolation via the Selector Widget ($)
#### Selector widget $
The $ component serves as a precise layout gatekeeper. It hooks into an active notifier, filters down to a targeted field variation using a selector function, and triggers an inner builder rebuild only when that specific selected item shifts values.  

#### Filtering Primitive State Mutations
```dart
$<HomeController, bool>(
  notifier: viewModel
  selector: (viewModel) => viewModel.loading,
  builder: (context, loading) {
    return loading ? const CircularProgressIndicator() : const TitleHeader();
  },
)
```

#### Grouping Values via Native Dart Records (Ultra fast)
```dart
$<HomeNotifier, ({String name, bool loading})>(
  notifier: notifier,
  selector: (notifier) => (name: notifier.user.name, loading: notifier.loading),
  builder: (context, data) => data.loading ? CircularProgressIndicator() : Text(data.name);
)
```


#### Complex Structural Models via MinProps
Extends you class with `MinProps` and implement a getter `props` with a `Record` with model attributes to listen any change in model.  
Using:
```dart
void changeName(String newName){
  update(user, (u)=> u.name = "Ivo Holanda");
}
```
and
```dart 
$<HomeStore, User>(
  notifier: store,
  selector: (store) => store.user,
  builder: (context, user) {
    return Text('Welcome back, ${user.name} | email: ${user.email}');
  },
)
```
With this, is not necessary create new instance of the object.

#### Lists/Maps/Sets

```dart 
$<HomeController, List<Item>>(
  notifier: controller,
  selector: (controller) => controller.items,
  builder: (context, items) => items.isEmpty 
    ? Text('No have items') 
    : ListView.builder(
      itemCount: items.length,
      .....
      itemBuilder: (context,index) => Text('${items[index].value}')
    );
)
```

#### Listen any changes in your Notifier
```dart
$<HomeViewModel, HomeViewModel>(
  notifier: viewModel,
  selector: (viewModel) => viewModel,
  builder: (context, viewModel) {
    return Text('Welcome back, ${viewModel.user.name}');
  },
)
```


#### Observations
You have option to import separately each file:  
```dart
import 'package:minimals_state_manager/min_providers.dart';
import 'package:minimals_state_manager/min_widgets.dart';
```
Or import full package
```dart
import 'package:minimals_state_manager/minimals_state_manager.dart';
```

### Benchmarks

