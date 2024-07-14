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