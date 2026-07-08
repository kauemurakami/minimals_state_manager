## 2.0.0
- Refact all package.
- Refact `MinController` to `MinNotifier` with a minimal code.
- Option to use/extends `ChangeNotifier` instead of `MinNotifier`, without using `ValueNotifier`, since all reactivity is now based on triggering `notifyListeners` from the chosen Notifier—either `ChangeNotifier` or `MinNotifier`.
- Remove `ValueNotifier` implements types (`.minx` extension).
- Use native and custom types/class now directly.
- Refactor `MinProvider` and `MinMultiProvider` modes, now accept any notifier based in `ChangeNotifier` ( alternative to the package `MinNotifier`, to use in your controller/viewModel/notifier).
- Add `onInit` and `onReady` in `MinNotifier` from `MinProvider` and `MinMultiProvider` widget `states`
- Create Selector widget (`$`) to listen specific values of the your Notifier, `ChangeNotifier` or `MinNotifier` based in `notifyListeners`.
- Selector widget `$` listen all types, primitive types, complex types, lists and combinations using `Records` (faster) see example.
- Refact `MinService` to avoid leaving junk in memory (alternative to the `get_it`).
- Refact package structure
- Add methods `onInit` and `onReady` to use in `MinNotifier` class
- Add check dispose to never call methods of `MinNotifier` if notifier is disposed.

## 1.0.6
 - Adding MinService again

## 1.0.5
  - Remake Providers and recovery methods
  - Remove unnecessary widgets and functions
  - Leaving as close as possible to native flutter, removing boilerplate such as `MinX` widget, `MinController`, `MinService` and others
  - Create providers to maintain the state in widget tree
  - Remake Complex Examples and Readme
  - Changing navigation so as not to inject controllers again, even keeping the state and changing only what changed

## 1.0.4
  - Fixing observable widget warnings $
  Refactoring Complex Examples and Readme
  - Changing navigation so as not to inject controllers again, even keeping the state and changing only what changed, this used the controller's onInit whenever it uses goNamed, in cases of
  - ShellRoute this would be bad, so we should opt for push

## 1.0.3
  - Fix Observable widget and dart doc

## 1.0.0
* Fix pub dev issues

## 0.2.0-beta

* minimals_State_manager start beta version
* Adding the MinService class, which is responsible for creating our permanent controllers, here called services, for being able to serve the entire application, along with its state
* Fixing dependency bugs

## 0.3.0-beta

* Fixing examples and usage
