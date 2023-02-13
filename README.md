

<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->


O Minimal State Manager é um projeto de estudos em versão alpha sobre o gerenciamento de estado em aplicativos Flutter. É uma implementação do que já é oferecido pelo próprio framework do Flutter, como o InheritedWidget, ValueNotifier, ChangeNotifier e ValueListenableBuilder.

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
