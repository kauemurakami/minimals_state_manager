[![Star on GitHub](https://img.shields.io/github/stars/kauemurakami/minimals_state_manager.svg?style=flat&logo=github&colorB=deeppink&label=stars)](https://github.com/kauemurakami/minimals_state_manager)  

  The minimals_state_manager package is a minimalist implementation of state management for Flutter apps, using only native Flutter packages. The goal is to simplify the process of managing states in your projects by providing an easy-to-use framework that takes full advantage of Flutter's native functionality.  

  For this, the package uses important packages such as InheritedWidget, ChangeNotifier, ValueNotifier, ValueNotifierBuilder and WidgetsBindingObserver to control the lifecycle of the application in its controllers.  

  With minimals_state_manager, you will have a minimal state management implementation that is easy to understand and that speeds up Flutter application development. **However, it is important to point out that this package is intended for study about state management, observables, lifecycle and best practices only and is not recommended for production as it is still in alpha version.**  


## Getting Started

```
$ flutter pub add minimals_state_manager
```
or add in your dependencies
```
dependencies:
  minimals_state_manager: <latest>
```

## Features
Embora ainda esteja em sua versão alpha, este gerenciador de estados já possui as seguintes características:  
    - Provedores de controllers MinProvider e MinMultiProvider.  
    - Widgets Observáveis.  
    - Widgets para uso dos controllers, podendo utilizar diferentes controllers no mesmo contexto.  

## Getting started

```
$ flutter pub add minimals_state_manager
```
or add in your dependencies
```
dependencies:
  minimals_state_manager: <latest>
```


## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
const like = 'sample';
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
