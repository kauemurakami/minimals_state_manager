[![Star on GitHub](https://img.shields.io/github/stars/kauemurakami/minimals_state_manager.svg?style=flat&logo=github&colorB=deeppink&label=stars)](https://github.com/kauemurakami/minimals_state_manager)  

  The minimals_state_manager package is a minimalist implementation of state management for Flutter apps, using only native Flutter packages. The goal is to simplify the process of managing states in your projects by providing an easy-to-use framework that takes full advantage of Flutter's native functionality.  

  For this, the package uses important packages such as InheritedWidget, ChangeNotifier, ValueNotifier, ValueNotifierBuilder and WidgetsBindingObserver to control the lifecycle of the application in its controllers.  

  With minimals_state_manager, you will have a minimal state management implementation that is easy to understand and that speeds up Flutter application development. **However, it is important to point out that this package is intended for study about state management, observables, lifecycle and best practices only and is not recommended for production as it is still in alpha version.**  

## Features
Embora ainda esteja em sua versão alpha, este gerenciador de estados já possui as seguintes características:  
    - MinProvider and MinMultiProvider are state management providers that allow you to easily manage and share the state of your Flutter application between different components. MinProvider is used for single state management, while MinMultiProvider is used for managing multiple states in a single provider. By using MinProvider and MinMultiProvider, you can simplify the process of managing state and reduce boilerplate code in your Flutter projects.  
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

This is simple example, for a more complete and complex, see the [`/example`](https://github.com/kauemurakami/minimals_state_manager/tree/main/example) folder.

Use the `MinProvider()` widget to provide a Controller for the child widget tree. If you need more than one Controller, you can use `MinMultiProvider()` to pass a list of controllers. 

```dart
MinProvider(
  controller: YourController(),
  child: YourPage()
)
```
or
```dart
MinMultiProvider(
  controllers: [YourController1(), YourController2()],
  child: YourPage()
)
```

```dart
void main() {
  runApp(
    MaterialApp(
      home: MinProvider(
        controller: MyController(), 
        child: const MyPage(),
      ),
    ),
  );
}

```
Use `MinX<YourController>()` widget to retrieve the available controller instance to use its methods and attributes in certain parts of the code.
```dart
MinX<YourController>(
 builder: (context, controller) => Widget
)
```
Use the observable widget `$()` to listen for updates to your controller's observable variable, this widget expects a `ValueNotifier` type listener, and has a function that returns the real value of the object passed, updating whenever necessary.
```dart
$(
 (count) => Text('Count $count'), // function real value as int
 listener: controller.count // ValueNotifier<int> as ValueNotififier<int>
)
```
```dart
class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: MinX<MyController>(
          builder: (context, controller) => Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                backgroundColor: Colors.lightGreen,
                onPressed: () => controller.increment(),
                child: const Icon(Icons.add),
              ),
              const SizedBox(
                height: 16.0,
              ),
              FloatingActionButton(
                backgroundColor: Colors.redAccent,
                onPressed: () => controller.decrement(),
                child: const Icon(Icons.remove),
              ),
              const SizedBox(
                height: 16.0,
              ),
              FloatingActionButton(
                onPressed: () => controller.refresh(),
                child: const Icon(Icons.refresh),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('check out the full example in the example folder'),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MinX<MyController>(
                        builder: (context, controller) => $(
                          (count) => Text(
                            'Count $count',
                            style: const TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          listener: controller.count,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
```

Extend `MinController` in your controller to get application lifecycles.
Add your methods and your observables.
```dart
class MyController extends MinController {
  @override
  void onInit() {
    print('init controller');
    super.onInit();
  }

  final count = 0.minx;

  increment() => count.value++;
  decrement() => count.value--;
  refresh() => count.value = 0;
}

```

## Additional information

Package is a work of studies about life cycles, dependency injection, objects and observable classes.  
Not recommended and not ready for production.